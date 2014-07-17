require_relative '../test_helper'

module Decks
  class MainMenuScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = MainMenuScreen.new release
    end

    def test_prints_the_artists
      reconfigure do |release|
        release.artists = [ 'Foo', 'Bar' ]
      end

      router.goto screen

      assert_printed terminal, 'Foo, Bar'
    end

    def test_prints_a_choice_to_change_the_artist
      router.goto screen

      assert_choice terminal, 'A'
    end

    def test_prints_the_name_of_the_release
      router.goto screen

      assert_printed terminal, release.name
    end

    def test_prints_a_choice_to_change_the_name
      router.goto screen

      assert_choice terminal, 'N'
    end

    def test_prints_out_that_the_release_is_a_compilation
      release.compilation = true
      router.goto screen

      assert_printed terminal, /Compilation\s*:\s*Yes/
    end

    def test_prints_a_choice_to_toggle_compilation_flag
      router.goto screen

      assert_choice terminal, 'C'
    end

    def test_prints_the_year_of_the_release
      router.goto screen

      assert_printed terminal, release.year
    end

    def test_prints_a_choice_change_the_year
      router.goto screen

      assert_choice terminal, 'Y'
    end

    def test_prints_the_label_of_the_release
      release.label = 'Lost Language'

      router.goto screen

      assert_printed terminal, release.label
    end

    def test_prints_a_choice_change_the_label
      router.goto screen

      assert_choice terminal, 'L'
    end

    def test_prints_the_catalogue_number_of_the_release
      release.catalogue_number = 'GALSO001'

      router.goto screen

      assert_printed terminal, release.catalogue_number
    end

    def test_prints_a_choice_change_the_catalogue_number
      router.goto screen

      assert_choice terminal, '#'
    end
  end
end
