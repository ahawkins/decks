module Decks
  class SetTrackMixScreen < BooleanInputScreen
    include Concord.new(:track, :next_state)

    def set(flag)
      track.mixed = flag
    end

    def prompt
      'Is this track mixed?'
    end
  end
end
