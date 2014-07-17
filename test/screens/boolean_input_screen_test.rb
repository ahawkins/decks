require_relative '../test_helper'

module Decks
  class BooleanInputSreen < ScreenTestCase
    class TestScreen < BooleanInputScreen
      include Concord.new(:next_state)

      attr_reader :flag

      def prompt
        'Is this awesome?'
      end

      def set(flag)
        @flag = flag
      end
    end

    def start
      screen = TestScreen.new placeholder
      router.goto screen
      yield router if block_given?
      screen
    end

    def test_prints_the_prompt_to_the_screen
      screen = start

      assert_printed terminal, screen.prompt
    end

    def test_prints_yes_no_options
      start

      assert_choice terminal, 'Y'
      assert_choice terminal, 'N'
    end

    def test_uses_y_for_yes
      screen = start do |cli|
        cli.input 'y'
      end

      assert screen.flag
    end

    def test_uses_n_for_no
      screen = start do |cli|
        cli.input 'n'
      end

      refute screen.flag
    end

    def test_unknown_input_prompt_for_a_retry
      screen = start do |cli|
        cli.input 'junk'
      end

      assert_equal screen, router.state
    end

    def test_goes_to_the_next_state_state_after_yes
      screen = start do |cli|
        cli.input 'y'
      end

      assert_equal placeholder, router.state
    end

    def test_goes_to_the_next_state_state_after_no
      start do |cli|
        cli.input 'n'
      end

      assert_equal placeholder, router.state
    end
  end
end
