require_relative '../test_helper'

module Decks
  class SetYearScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetYearScreen.new release, placeholder
    end

    def test_assigns_the_year
      screen.set 2000

      assert_equal 2000, release.year
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter release year', screen.prompt
    end
  end
end
