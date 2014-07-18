module Decks
  class ReleaseFileNameFactory
    include SanitizationHelpers

    include Concord.new(:release, :prefix)

    def name
      parts = [ ]

      parts << (compilation? ? 'VA' : artist_names)

      parts << release.name

      parts << "(#{catalogue_number})" if catalogue_number?

      parts << format.upcase
      parts << 'LOSSLESS' if lossless?
      parts << year
      parts << 'DECKS'

      parts.map { |part| sanitize(part) }.join('-')
    end

    def path
      release.dirname.join name
    end

    def nfo
      file :nfo
    end

    def sfv
      file :sfv
    end

    def cover
      file :jpg
    end

    def proof
      file :jpg, :proof
    end

    def m3u
      file :m3u
    end

    def mixed_m3u
      file :m3u, :mixed
    end

    def unmixed_m3u
      file :m3u, :unmixed
    end

    private
    def file(extension, tag = nil)
      parts = [ prefix, name, tag ].compact

      path.join "#{parts.join('-')}.#{extension}".downcase
    end

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
