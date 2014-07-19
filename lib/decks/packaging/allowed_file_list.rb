module Decks
  class AllowedFileList
    include Concord.new(:release)
    include Enumerable

    def each(&block)
      list.each(&block)
    end

    private
    def list
      files = release.tracks.map(&:path)
      files << release.cover if release.cover?
      files
    end
  end
end
