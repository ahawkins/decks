require_relative '../test_helper'

module Decks
  class SetTrackFileScreenTest < ScreenTestCase
    attr_reader :screen

    def track
      release[0]
    end

    def setup
      super

      @screen = SetTrackFileScreen.new track, release.path, placeholder
    end

    def test_sets_files
      screen.set release.path.join('example.mp3')

      assert_equal release.path.join('example.mp3'), track.path
    end

    def test_only_prints_mp3_and_flac
      assert_equal '*.{mp3,flac}', screen.files
    end
  end
end
