module Decks
  class Configuration
    Track = Struct.new :number, :title, :artist, :cue, :mixed do
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

    attr_writer :compilation
    attr_writer :lossless

    attr_accessor :tracks

    def initialize(path)
      value = path.to_s
      value.chop! if value.end_with?('/', '\\')

      @path = Pathname.new value

      @tracks = [ ]
      @artists = [ ]
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
      path.children
    end

    def move(new_path)
      return unless new_path != path

      base_path = new_path.dirname

      FileUtils.mv path, new_path

      tracks.each do |track|
        track.path = new_path.join track.basename
      end

      @path = new_path
    end
  end
end
