require_relative '../test_helper'

module Decks
  class SetNameScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetNameScreen.new release, placeholder
    end

    def test_assigns_the_name
      screen.set 'GALSOCD'

      assert_equal 'GALSOCD', release.name
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter release name', screen.prompt
    end
  end
end
