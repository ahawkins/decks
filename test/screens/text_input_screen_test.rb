require_relative '../test_helper'

module Decks
  class TextInputScreenTest < ScreenTestCase
    class TestScreen < TextInputScreen
      include Concord.new(:next_state)

      attr_reader :text

      def prompt
        'Input some text'
      end

      def set(text)
        @text = text
      end
    end

    def test_prints_the_prompt_to_the_screen
      screen = TestScreen.new placeholder
      router.goto screen

      assert_printed terminal, screen.prompt
    end

    def test_passes_the_text_for_processing
      screen = TestScreen.new placeholder
      router.goto screen

      router.input 'Adam'

      assert_equal 'Adam', screen.text
    end

    def test_goes_to_the_next_state_state_are_input
      screen = TestScreen.new placeholder
      router.goto screen

      router.input 'Adam'

      assert_equal placeholder, router.state
    end
  end
end
