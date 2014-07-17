require_relative '../test_helper'

module Decks
  class SelectFileScreenTest < ScreenTestCase
    class SelectTextFileScreen < SelectFileScreen
      attr_reader :selected

      def files
        '*.txt'
      end

      def set(path)
        @selected = path
      end
    end

    def path
      release.path
    end

    def start
      reconfigure do |release|
        yield release if block_given?
      end

      screen = SelectTextFileScreen.new release, path, placeholder
      router.goto screen
      screen
    end
    alias_method :restart, :start

    def test_shows_a_list_of_available_files
      start do |release|
        release.touch 'file1.txt'
        release.touch 'file2.txt'
      end

      assert_printed terminal, 'file1.txt'
      assert_printed terminal, 'file2.txt'
    end

    def test_can_change_the_file_to_another
      screen = start do |release|
        release.touch 'file1.txt'
        release.touch 'file2.txt'
      end

      router.input '1'

      assert_equal release.path.join('file1.txt').to_s, screen.selected
    end

    def test_fail_if_input_does_not_map_to_a_file
      start do |release|
        release.touch 'file1.txt'
        release.touch 'file2.txt'
      end

      assert_raises Router::UnknownCommandError do
        router.input '9'
      end
    end

    def test_shows_an_error_if_no_files
      start

      assert_state ErrorScreen, router
    end

    def test_can_reload_to_pickup_new_files
      start do |release|
        release.touch 'file1.txt'
      end

      refute_printed terminal, 'new_file.txt'

      restart do |release|
        release.touch 'new_file.txt'
      end

      router.input 'r'

      assert_printed terminal, 'new_file.txt'
    end

    def test_goes_back_to_the_next_state_screen_after_successful_input
      start do |release|
        release.touch 'file1.txt'
      end

      router.input '1'

      assert_equal placeholder, router.state
    end
  end
end
