require_relative '../test_helper'

module Decks
  class SetTrackNumberScreenTest < ScreenTestCase
    attr_reader :screen

    def track
      release[0]
    end

    def setup
      super

      @screen = SetTrackNumberScreen.new track, placeholder
    end

    def test_assigns_the_number
      screen.set 5

      assert_equal 5, track.number
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter track # for this track', screen.prompt
    end
  end
end
