module Decks
  class ImageManifest
    include Concord.new(:configuration, :file_names)
    include Enumerable

    def cover
      return unless configuration.cover?
      Image.new configuration.cover, file_names.cover
    end

    def each(&block)
      list = [ ]
      list << cover if cover
      list.each(&block)
    end
  end
end
