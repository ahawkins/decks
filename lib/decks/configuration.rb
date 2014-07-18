module Decks
  class Configuration
    Track = Struct.new :number, :disc, :title, :artist, :cue, :log, :mixed do
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

      def log?
        !!log
      end

      def basename
        path.basename
      end

      def extname
        path.extname
      end

      def cue_path
        path.sub /\.(mp3|flac)$/, '.cue'
      end

      def log_path
        path.sub /\.(mp3|flac)$/, '.log'
      end
    end

    Cue = Struct.new :number, :text do
      def disc
        number
      end

      def track
        number
      end
    end

    Log = Struct.new :number, :text do
      def disc
        number
      end

      def track
        number
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

    attr_accessor :cues
    attr_accessor :logs

    def initialize(path)
      @path = Pathname.new path.to_s
      @tracks = [ ]
      @artists = [ ]
      @cues = [ ]
      @logs = [ ]
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
  end
end
