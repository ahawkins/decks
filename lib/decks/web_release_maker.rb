module Decks
  class WebReleaseMaker
    include SanitizationHelpers
    include Concord.new(:config)

    def make
      clear

      base_path = config.dirname
      release_path = base_path.join name

      if release_path != config.path
        FileUtils.mv config.path, release_path
        config.path = release_path

        config.tracks.each do |track|
          track.path = release_path.join track.basename
        end
      end

      config.tracks.each do |track|
        write_tags track

        track_basename = ('%02d-%s-%s-%s' % [
          track.number,
          sanitize(track.artist),
          sanitize(track.title),
          'DECKS',
        ]).downcase

        new_path = path.join "#{track_basename}#{track.extname}"

        if track.path != new_path
          FileUtils.mv track.path, new_path
          track.path = new_path
        end

        if track.cue?
          File.open track.cue_path, 'w' do |cue|
            cue << track.cue
          end
        end
      end

      FileUtils.touch nfo_path
      FileUtils.touch sfv_path

      if mixed_and_unmixed_tracks?
        create_playlist continuous_mixes_m3u_path, continuous_mixes
        create_playlist unmixed_m3u_path, unmixed_tracks
      end

      create_playlist m3u_path, config.tracks
    end

    private
    def path
      config.path
    end

    def write_tags(track)
      AudioFile.new track.path do |tags|
        tags.track = track.number
        tags.total_tracks = config.tracks.size

        tags.title = track.title
        tags.artist = track.artist

        tags.album = config.name
        tags.album_artist = artist_names

        tags.year = config.year

        tags.compilation = config.compilation?
      end
    end

    def name
      parts = [ ]

      parts << (compilation? ? 'VA' : artist_names)

      parts << config.name

      yield parts if block_given?

      parts << config.format.upcase
      parts << "(#{config.catalogue_number})" if config.catalogue_number
      parts << 'LOSSLESS' if config.lossless?
      parts << config.year
      parts << 'DECKS'

      parts.map { |part| sanitize(part) }.join('-')
    end

    def release_filename
      parts = name do |tags|
        yield tags if block_given?
      end
      parts.downcase
    end

    def artist_names
      config.artists.join ' & '
    end

    def nfo_path
      path.join "00-#{release_filename}.nfo"
    end

    def sfv_path
      path.join "00-#{release_filename}.sfv"
    end

    def m3u_path
      path.join "00-#{release_filename}.m3u"
    end

    def cover_path
      path.join "00-#{release_filename}.jpg"
    end

    def continuous_mixes_m3u_path
      base = release_filename do |parts|
        last = parts.pop
        parts << "#{last.dup} (Continuous Mixes)"
      end

      path.join "00-#{base}.m3u"
    end

    def unmixed_m3u_path
      base = release_filename do |parts|
        last = parts.pop
        parts << "#{last.dup} (Unmixed)"
      end

      path.join "00-#{base}.m3u"
    end

    def configured_files
      config.tracks.map(&:path)
    end

    def clear
      junk_files = config.files - configured_files
      junk_files.each do |junk_file|
        FileUtils.rm_rf junk_file
      end
    end

    def continuous_mixes
      tracks.select(&:mixed?)
    end

    def continuous_mixes?
      continuous_mixes.any?
    end

    def unmixed_tracks
      tracks.reject(&:mixed?)
    end

    def mixed_and_unmixed_tracks?
      tracks.any?(&:mixed?) && tracks.any?(&:unmixed?)
    end

    def create_playlist(path, tracks)
      File.open path, 'w' do |playlist|
        tracks.each do |track|
          playlist.puts track.basename
        end
      end
    end

    def compilation?
      config.compilation?
    end

    def tracks
      config.tracks
    end
  end
end
