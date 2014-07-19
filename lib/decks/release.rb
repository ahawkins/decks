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
      builder.package!
    end

    private
    def build_validator
      case format
      when /web/i
        WebValidator.new configuration
      else
        fail "Cannot handle #{format}"
      end
    end

    def build_builder
      case format
      when /web/i
        WebPackager.build configuration
      else
        fail "Cannot handle #{format}"
      end
    end

    def configuration
      __getobj__
    end
  end
end
