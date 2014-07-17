require_relative '../test_helper'

module Decks
  class SetTrackArtistScreenTest < ScreenTestCase
    attr_reader :screen

    def track
      release[0]
    end

    def setup
      super

      @screen = SetTrackArtistScreen.new track, placeholder
    end

    def test_assigns_the_name
      screen.set 'Re:Locate'

      assert_equal 'Re:Locate', track.artist
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter artist for this track', screen.prompt
    end
  end
end
