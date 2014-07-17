require_relative '../test_helper'

module Decks
  class SetArtistScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetArtistScreen.new release, placeholder
    end

    def test_reads_comma_separated_artists
      screen.set 'Foo, Bar'

      assert_equal [ 'Foo', 'Bar' ], release.artists
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter release artist', screen.prompt
    end
  end
end
