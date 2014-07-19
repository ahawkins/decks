module Decks
  class ImageManifest
    include Concord.new(:configuration, :file_names)
    include Enumerable

    def cover
      return unless cover_image
      Image.new cover_image, file_names.cover
    end

    def proof
      return unless proof_image
      Image.new proof_image, file_names.proof
    end

    def each(&block)
      [ cover, proof ].compact.each(&block)
    end

    private
    def images
      Pathname.glob configuration.path.join('*.{jpg,jpeg}')
    end

    def proof_image
      images.find do |image|
        image.to_s =~ /proof/i
      end
    end

    def cover_image
      if images.size == 1 && !proof_image
        images.first
      elsif images.size == 2
        images.find do |image|
          image != proof
        end
      else
        images.find do |image|
          image.to_s =~ /cover|artwork/i
        end
      end
    end
  end
end
