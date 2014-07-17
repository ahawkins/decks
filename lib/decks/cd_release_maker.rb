module Decks
  class CdReleaseMaker
    include SanitizationHelpers
    include Concord.new(:config)

    def make
      clear

      base_path = config.dirname
      release_path = base_path.join name

      FileUtils.mv config.path, release_path
      config.path = release_path

      # Set the tracks back to the correct paths since their root
      # directory has changed

      config.tracks.each do |track|
        track.path = release_path.join track.basename
      end

      config.tracks.each do |track|
        write_tags track

        track_basename = ('%d%02d-%s-%s-%s' % [
          track.disc,
          track.number,
          sanitize(track.artist),
          sanitize(track.title),
          'DECKS'
        ]).downcase

        new_path = path.join "#{track_basename}#{track.extname}"

        FileUtils.mv track.path, new_path
        track.path = new_path

        if track.cue?
          File.open track.cue_path, 'w' do |cue|
            cue << track.cue
          end
        end

        if track.log?
          File.open track.log_path, 'w' do |log|
            log << track.log
          end
        end
      end

      # FileUtils.mv config.cover_path, File.join(config.path, cover_path)

      FileUtils.touch nfo_path
      FileUtils.touch sfv_path

      create_playlist m3u_path, config.tracks
      create_per_disc_playlists
    end

    private
    def path
      config.path
    end

    def write_tags(track)
      AudioFile.new track.path do |tags|
        tags.disc = track.disc
        tags.total_discs = total_discs

        tags.track = track.number
        tags.total_tracks = tracks_on_disc track.disc

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
      path.join "000-#{release_filename}.nfo"
    end

    def sfv_path
      path.join "000-#{release_filename}.sfv"
    end

    def m3u_path
      path.join "000-#{release_filename}.m3u"
    end

    def cover_path
      path.join "000-#{release_filename}.jpg"
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

    def create_playlist(path, tracks)
      File.open path, 'w' do |playlist|
        tracks.each do |track|
          playlist.puts track.basename
        end
      end
    end

    def total_discs
      config.tracks.map(&:disc).uniq.size
    end

    def tracks_on_disc(number)
      config.tracks.count do |track|
        track.disc == number
      end
    end

    def create_per_disc_playlists
      per_disc = config.tracks.group_by(&:disc)

      per_disc.each_pair do |disc, list|
        m3u = "#{disc}00-#{release_filename}.m3u"
        create_playlist path.join(m3u), list
      end
    end
  end
end
