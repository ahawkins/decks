require_relative '../test_helper'

module Decks
  class SetCueScreenTest < ScreenTestCase
    attr_reader :screen

    def track
      release[0]
    end

    def setup
      super

      @screen = SetCueScreen.new track, release.path, placeholder
    end

    def test_sets_cue_from_the_file
      reconfigure do |release|
        release.touch 'example.cue', 'fake cue'
      end

      screen.set release.path.join('example.cue')

      assert_equal 'fake cue', track.cue
    end

    def test_only_prints_cue_files
      assert_equal '*.cue', screen.files
    end
  end
end
