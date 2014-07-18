module Decks
  class Release < DelegateClass(Configuration)
    class << self
      def from_path(path)
        release = new Configuration.new(path)
        yield release if block_given?
        release
      end
    end

    def rules
      @rules ||= build_validator
    end

    def builder
      @builder ||= build_builder
    end

    def ok?
      rules.valid?
    end

    def problems?
      !ok?
    end

    def problems
      rules.errors
    end

    def release!
      builder.make
    end

    def glob(match)
      Pathname.glob dirname.join(match)
    end

    def grep(matcher)
      files.find do |file|
        file.to_s =~ matcher
      end
    end

    # FIXME: I would like to better encapsulate the names of these files
    def sfv
      grep /\.sfv$/
    end

    def nfo
      grep /\.nfo$/
    end

    def playlist
      grep /decks\.m3u$/
    end

    def mixed_playlist
      grep /decks-mixed\.m3u$/
    end

    def unmixed_playlist
      grep /decks-unmixed\.m3u$/
    end

    private
    def build_validator
      case format
      when /web/i
        WebReleaseValidator.new configuration
      when /cd/i
        CdReleaseValidator.new configuration
      else
        fail "Cannot handle #{format}"
      end
    end

    def build_builder
      case format
      when /web/i
        WebReleaseMaker.new configuration
      when /cd/i
        CdReleaseMaker.new configuration
      else
        fail "Cannot handle #{format}"
      end
    end

    def configuration
      __getobj__
    end
  end
end
