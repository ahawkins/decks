module Decks
  class Configuration
    Track = Struct.new :number, :title, :artist, :cue,  :mixed do
      attr_reader :path

      def path=(value)
        @path = Pathname.new value
      end

      def mixed?
        !!mixed
      end

      def unmixed?
        !mixed?
      end

      def cue?
        !!cue
      end

      def rename(new_path)
        return if new_path == path
        path.rename new_path
        @path = new_path
      end

      def basename
        path.basename
      end
    end

    attr_reader :path

    attr_accessor :artists
    attr_accessor :name
    attr_accessor :year

    attr_accessor  :label
    attr_accessor :catalogue_number

    attr_accessor :format
    attr_accessor :cover_path

    attr_writer :compilation
    attr_writer :lossless

    attr_accessor :tracks

    def initialize(path)
      @path = Pathname.new path.to_s
      @tracks = [ ]
      @artists = [ ]
    end

    def path=(value)
      @path = Pathname.new value.to_s
    end

    def compilation?
      !!@compilation
    end

    def lossless?
      !!@lossless
    end

    def [](index)
      tracks[index]
    end

    def basename
      path.basename
    end

    def dirname
      path.dirname
    end

    def files
      Dir[path.join('**', '*.*')].map do |file|
        Pathname.new file
      end
    end

    def cover?
      !!cover
    end

    def cover
      return unless images.size == 1
      images.first
    end

    # Move the directory and all referenced files inside that directory
    def move(new_path)
      return unless new_path != path

      base_path = new_path.dirname

      FileUtils.mv path, new_path

      tracks.each do |track|
        track.path = new_path.join track.basename
      end

      @path = new_path
    end

    private
    def images
      Pathname.glob path.join('*.{jpg,jpeg}')
    end
  end
end
