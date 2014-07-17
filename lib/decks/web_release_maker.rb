module Decks
  class WebReleaseMaker
    include SanitizationHelpers
    include Concord.new(:config)

    def make
      clear

      base_path = File.dirname config.path
      release_path = File.join base_path, name

      config.tracks.each do |track_config|
        file = AudioFile.new track_config.path

        file.track = track_config.number
        file.total_tracks = config.tracks.size

        file.title = track_config.title
        file.artist = track_config.artist

        file.album = config.name
        file.album_artist = artist_names

        file.year = config.year

        file.compilation = config.compilation?

        track_filename = '%02d-%s-%s-%s' % [
          track_config.number,
          sanitize(track_config.artist),
          sanitize(track_config.title),
          'DECKS'
        ]

        file.rename track_filename.downcase

        track_config.path = file.path

        if track_config.cue
          File.open track_config.cue_path, 'w' do |cue|
            cue << track_config.cue
          end
        end
      end

      FileUtils.mv config.cover_path, File.join(config.path, cover_path)

      FileUtils.mv config.path, release_path

      FileUtils.touch File.join(release_path, nfo_path)
      FileUtils.touch File.join(release_path, sfv_path)

      if continuous_mixes?
        create_playlist File.join(release_path, continuous_mixes_m3u_path), continuous_mixes
      end

      if unmixed_tracks?
        create_playlist File.join(release_path, unmixed_m3u_path), unmixed_tracks
      end

      create_playlist File.join(release_path, m3u_path), config.tracks


    end

    private
    def name
      parts = [ ]

      parts << artist_names
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
      "00-#{release_filename}.nfo"
    end

    def sfv_path
      "00-#{release_filename}.sfv"
    end

    def m3u_path
      "00-#{release_filename}.m3u"
    end

    def cover_path
      "00-#{release_filename}.jpg"
    end

    def continuous_mixes_m3u_path
      base = release_filename do |parts|
        last = parts.pop
        parts << "#{last.dup} (Continuous Mixes)"
      end

      "00-#{base}.m3u"
    end

    def unmixed_m3u_path
      base = release_filename do |parts|
        last = parts.pop
        parts << "#{last.dup} (Unmixed)"
      end

      "00-#{base}.m3u"
    end

    def configured_files
      track_files = config.tracks.map do |track|
        track.path.to_s
      end

      set = Set.new track_files
      set << config.cover_path.to_s if config.cover_path
      set
    end

    def clear
      junk_files = existing_files - configured_files
      junk_files.each do |junk_file|
        FileUtils.rm_rf junk_file
      end
    end

    def existing_files
      Set.new(Dir[config.path.join('**', '*')])
    end

    def continuous_mixes
      config.tracks.select(&:mixed?)
    end

    def continuous_mixes?
      continuous_mixes.any?
    end

    def unmixed_tracks
      config.tracks.reject(&:mixed?)
    end

    def unmixed_tracks?
      unmixed_tracks.any?
    end

    def create_playlist(path, tracks)
      File.open path, 'w' do |playlist|
        tracks.each do |track|
          playlist.puts File.basename(track.path)
        end
      end
    end
  end
end
