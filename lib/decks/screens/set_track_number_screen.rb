module Decks
  class SetTrackNumberScreen < NumberInputScreen
    include Concord.new(:track, :next_state)

    def set(number)
      track.number = number
    end

    def prompt
      'Enter track # for this track'
    end
  end
end
