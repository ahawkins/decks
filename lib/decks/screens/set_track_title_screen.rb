module Decks
  class SetTrackTitleScreen < TextInputScreen
    include Concord.new(:track, :next_state)

    def set(text)
      track.title = text
    end

    def prompt
      'Enter artist for this track'
    end
  end
end
