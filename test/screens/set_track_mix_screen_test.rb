require_relative '../test_helper'

module Decks
  class SetTrackMixScreenTest < ScreenTestCase
    attr_reader :screen

    def track
      release[0]
    end

    def setup
      super

      @screen = SetTrackMixScreen.new track, placeholder
    end

    def test_assigns_the_mixed_flag
      screen.set true

      assert track.mixed?
    end

    def test_prints_a_useful_prompt
      assert_equal 'Is this track mixed?', screen.prompt
    end
  end
end
