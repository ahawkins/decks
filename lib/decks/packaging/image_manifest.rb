module Decks
  class ImageManifest
    include Concord.new(:configuration, :file_names)
    include Enumerable

    def cover
      return unless configuration.cover?
      Image.new configuration.cover, file_names.cover
    end

    def proof
      return unless configuration.proof?
      Image.new configuration.proof, file_names.proof
    end

    def each(&block)
      [ cover, proof ].compact.each(&block)
    end
  end
end
