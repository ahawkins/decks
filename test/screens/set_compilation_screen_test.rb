require_relative '../test_helper'

module Decks
  class SetCompilationScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetCompilationScreen.new release, placeholder
    end

    def test_sets_the_compilation_flag
      screen.set true

      assert release.compilation?
    end

    def test_prints_a_useful_prompt
      assert_equal 'Is this release a compilation?', screen.prompt
    end
  end
end
