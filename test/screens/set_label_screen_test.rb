require_relative '../test_helper'

module Decks
  class SetLabelScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetLabelScreen.new release, placeholder
    end

    def test_assigns_the_label
      screen.set 'GALSOCD'

      assert_equal 'GALSOCD', release.label
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter label', screen.prompt
    end
  end
end
