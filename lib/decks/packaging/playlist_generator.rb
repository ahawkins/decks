module Decks
  class PlaylistGenerator
    include Concord.new(:track_list, :names)

    def all_files
      sorted.map do |track|
        names.track_file_name track
      end
    end

    def mixed_files
      sorted.select(&:mixed?).map do |track|
        names.track_file_name track
      end
    end

    def unmixed_files
      sorted.select(&:unmixed?).map do |track|
        names.track_file_name track
      end
    end

    def split?
      mixed_files.any? && unmixed_files.any?
    end

    private
    def sorted
      track_list.sort do |t1, t2|
        t1.number <=> t2.number
      end
    end
  end
end
