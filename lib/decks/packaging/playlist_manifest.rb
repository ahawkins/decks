module Decks
  class PlaylistManifest
    include Concord.new(:track_list, :names)
    include Enumerable

    def release
      Playlist.new names.playlist, all_files
    end

    def mixed
      Playlist.new names.mixed_playlist, mixed_files
    end

    def unmixed
      Playlist.new names.unmixed_playlist, unmixed_files
    end

    def each(&block)
      list = [ release ]

      if split?
        list << mixed
        list << unmixed
      end

      list.each(&block)
    end

    private
    def sorted
      track_list.sort do |t1, t2|
        t1.number <=> t2.number
      end
    end

    def all_files
      list = sorted.map do |track|
        names.track track
      end
    end

    def mixed_files
      sorted.select(&:mixed?).map do |track|
        names.track track
      end
    end

    def unmixed_files
      sorted.select(&:unmixed?).map do |track|
        names.track track
      end
    end

    def split?
      mixed_files.any? && unmixed_files.any?
    end
  end
end
