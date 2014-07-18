module Decks
  class TrackFileNameFactory
    include SanitizationHelpers

    include Concord.new(:track, :prefix)

    def name
      "#{base}#{extname}"
    end

    def cue
      dirname.join "#{base}.cue"
    end

    def path
      dirname.join name
    end

    private
    def base
      ('%s%02d-%s-%s-%s' % [
        prefix.to_s,
        track.number,
        sanitize(track.artist),
        sanitize(track.title),
        'DECKS',
      ]).downcase
    end

    def dirname
      track.path.dirname
    end

    def extname
      track.path.extname
    end
  end
end
