require_relative '../test_helper'

module Decks
  class NumberInputScreenTest < ScreenTestCase
    class TestScreen < NumberInputScreen
      include Concord.new(:next_state)

      attr_reader :number

      def prompt
        'Input some text'
      end

      def set(number)
        @number = number
      end
    end

    def test_prints_the_prompt_to_the_screen
      screen = TestScreen.new placeholder
      router.goto screen

      assert_printed terminal, screen.prompt
    end

    def test_passes_the_number_for_processing
      screen = TestScreen.new placeholder
      router.goto screen

      router.input '1234'

      assert_equal 1234, screen.number
    end

    def test_prompts_for_input_again_if_input_is_not_a_number
      screen = TestScreen.new placeholder
      router.goto screen

      router.input 'asdfadsfa'

      assert_equal screen, router.state
    end

    def test_goes_to_the_next_state_state_are_input
      screen = TestScreen.new placeholder
      router.goto screen

      router.input '1234'

      assert_equal placeholder, router.state
    end
  end
end
