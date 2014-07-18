module Decks
  class ConfigurationDSL
    class CueLogDSL
      def initialize(object)
        @object = object
      end

      def disc=(number)
        object.number = number
      end

      def track=(number)
        object.number = number
      end

      def text=(text)
        object.text = text
      end

      private
      def object
        @object
      end
    end

    def initialize(fixture_path, config)
      @fixture_path = fixture_path
      @config = config
    end

    def artist=(name)
      config.artists = [ name ]
    end

    def artists=(values)
      config.artists = values
    end

    def name=(value)
      config.name = value
    end

    def year=(value)
      config.year = value
    end

    def catalogue_number=(value)
      config.catalogue_number = value
    end

    def compilation=(value)
      config.compilation = value
    end

    def lossless=(value)
      config.lossless = value
    end

    def format=(value)
      config.format = value
    end

    def mp3(path)
      mp3_path = config.path.join "#{path}.mp3"
      FileUtils.copy_file fixture_path.join('example.mp3'), mp3_path
      mp3_path
    end

    def track(path)
      mp3_path = mp3 path.gsub('.mp3', '')

      entry = Configuration::Track.new
      entry.path = mp3_path

      yield entry if block_given?

      config.tracks << entry
    end

    def image(path)
      FileUtils.copy_file fixture_path.join('cover.jpg'), config.path.join(path)
    end

    def touch(path, content = '')
      File.open config.path.join(path), 'w' do |file|
        file.write content
      end
    end

    def cue
      entry = Configuration::Cue.new
      yield CueLogDSL.new(entry)
      config.cues << entry
    end

    def log
      entry = Configuration::Log.new
      yield CueLogDSL.new(entry)
      config.logs << entry
    end

    def logs
      config.logs
    end

    def [](number)
      tracks[number]
    end

    def tracks
      config.tracks
    end

    private
    def config
      @config
    end

    def fixture_path
      @fixture_path
    end
  end
end
