module Decks
  class FileNameGenerator
    include Concord.new(:release)
    include SanitizationHelpers

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

    def playlist
      file :m3u
    end

    def mixed_playlist
      file :m3u, :mixed
    end

    def unmixed_playlist
      file :m3u, :unmixed
    end

    def track(t)
      ('%02d-%s-%s-%s%s' % [
        t.number,
        sanitize(t.artist),
        sanitize(t.title),
        'DECKS',
        t.path.extname
      ]).downcase
    end

    private
    def file(extension, tag = nil)
      parts = [ name, tag ].compact

      "#{parts.join('-')}.#{extension}".downcase
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
