module Decks
  class ReleaseFileNameFactory
    include SanitizationHelpers

    include Concord.new(:release)

    def name(*tags)
      parts = [ ]

      parts << (compilation? ? 'VA' : artist_names)

      parts << release.name

      parts << "(#{catalogue_number})" if catalogue_number?

      parts = parts + tags.map { |t| t.to_s.upcase }

      parts << format.upcase
      parts << 'LOSSLESS' if lossless?
      parts << year
      parts << 'DECKS'

      parts.map { |part| sanitize(part) }.join('-')
    end

    def file(*tags)
      name(*tags).downcase
    end

    def nfo
      "#{file}.nfo"
    end

    def sfv
      "#{file}.sfv"
    end

    def jpg
      "#{file}.jpg"
    end

    def proof
      "#{file(:proof)}.jpg"
    end

    def m3u
      "#{file}.m3u"
    end

    def mixed_m3u
      "#{file(:mixed)}.m3u"
    end

    def unmixed_m3u
      "#{file(:unmixed)}.m3u"
    end

    private
    def compilation?
      release.compilation?
    end

    def catalogue_number
      release.catalogue_number
    end

    def catalogue_number?
      !!catalogue_number
    end

    def lossless?
      release.lossless?
    end

    def format
      release.format
    end

    def artist_names
      release.artists.join(' & ')
    end

    def year
      release.year
    end
  end
end
