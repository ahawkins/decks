module Decks
  class TrackFileNameFactory
    include SanitizationHelpers

    include Concord.new(:track)

    def name
      "#{base}#{track.extname}"
    end

    def cue
      "#{base}.cue"
    end

    private
    def base
      ('%02d-%s-%s-%s' % [
        track.number,
        sanitize(track.artist),
        sanitize(track.title),
        'DECKS',
      ]).downcase
    end
  end
end
