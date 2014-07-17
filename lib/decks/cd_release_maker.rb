module Decks
  class CdReleaseMaker
    include SanitizationHelpers
    include Concord.new(:config)

    def make
      clear

      base_path = File.dirname config.path
      release_path = File.join base_path, name

      config.tracks.each do |track_config|
        file = AudioFile.new track_config.path

        file.disc = track_config.disc
        file.total_discs = total_discs

        file.track = track_config.number
        file.total_tracks = tracks_on_disc file.disc

        file.title = track_config.title
        file.artist = track_config.artist

        file.album = config.name
        file.album_artist = artist_names

        file.year = config.year

        file.compilation = config.compilation?

        track_filename = '%d%02d-%s-%s-%s' % [
          track_config.disc,
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

        if track_config.log
          File.open track_config.log_path, 'w' do |log|
            log << track_config.log
          end
        end
      end

      FileUtils.mv config.cover_path, File.join(config.path, cover_path)

      FileUtils.mv config.path, release_path

      FileUtils.touch File.join(release_path, nfo_path)
      FileUtils.touch File.join(release_path, sfv_path)

      create_playlist File.join(release_path, m3u_path), config.tracks
      create_per_disc_playlists release_path
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
      "000-#{release_filename}.nfo"
    end

    def sfv_path
      "000-#{release_filename}.sfv"
    end

    def m3u_path
      "000-#{release_filename}.m3u"
    end

    def cover_path
      "000-#{release_filename}.jpg"
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

    def create_playlist(path, tracks)
      File.open path, 'w' do |playlist|
        tracks.each do |track|
          playlist.puts File.basename(track.path)
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

    def create_per_disc_playlists(base_path)
      per_disc = config.tracks.group_by(&:disc)

      per_disc.each_pair do |disc, list|
        m3u = "#{disc}00-#{release_filename}.m3u"
        create_playlist File.join(base_path, m3u), list
      end
    end
  end
end
