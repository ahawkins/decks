module Decks
  class SetTrackArtistScreen < TextInputScreen
    include Concord.new(:track, :next_state)

    def set(text)
      track.artist = text
    end

    def prompt
      'Enter artist for this track'
    end
  end
end
