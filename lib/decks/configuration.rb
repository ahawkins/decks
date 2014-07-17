module Decks
  class Configuration
    Track = Struct.new :number, :disc, :title, :artist, :path, :cue, :log, :mixed do
      def mixed?
        !!mixed
      end

      def name
        return unless path

        File.basename path
      end

      def cue_path
        path.gsub /(mp3|flac)$/, 'cue'
      end

      def log_path
        path.gsub /(mp3|flac)$/, 'log'
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
      @path = path
      @tracks = [ ]
      @artists = [ ]
      @cues = [ ]
      @logs = [ ]
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
      File.basename path
    end
  end
end
