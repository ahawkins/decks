module Decks
  class WebReleaseMaker
    include SanitizationHelpers
    include Concord.new(:config)

    def make
      clear

      pathnames = ReleaseFileNameFactory.new config, '00'

      config.move pathnames.path

      config.tracks.each do |track|
        write_tags track

        track_factory = TrackFileNameFactory.new track, prefix = nil

        track.move track_factory.path

        if track.cue?
          File.open track_factory.cue, 'w' do |cue|
            cue << track.cue
          end
        end
      end

      FileUtils.touch pathnames.nfo
      FileUtils.touch pathnames.sfv

      if mixed_and_unmixed_tracks?
        create_playlist pathnames.mixed_m3u, continuous_mixes
        create_playlist pathnames.unmixed_m3u, unmixed_tracks
      end

      create_playlist pathnames.m3u, config.tracks

      config.cover.rename pathnames.cover if config.cover?
    end

    private
    def write_tags(track)
      AudioFile.new track.path do |tags|
        tags.track = track.number
        tags.total_tracks = config.tracks.size

        tags.title = track.title
        tags.artist = track.artist

        tags.album = config.name
        tags.album_artist = config.artists.join(' & ')

        tags.year = config.year

        tags.compilation = config.compilation?
      end
    end

    def configured_files
      list = config.tracks.map(&:path)
      list << config.cover if config.cover?
      list
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

    def tracks
      config.tracks
    end
  end
end
