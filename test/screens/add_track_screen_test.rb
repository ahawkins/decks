require_relative '../test_helper'

module Decks
  class AddTrackScreenTest < MiniTest::Unit::TestCase
    def test_assigns_metadata_from_the_file_if_present
      release = configure do |release|
        release.mp3 'test'
      end

      path = release.path.join('test.mp3')

      Mp3Track.new path do |mp3|
        mp3.artist = 'Given Artist'
        mp3.title = 'Given Title'
        mp3.track = 1
        mp3.disc = 2
      end

      tracks = release.tracks

      screen = AddTrackScreen.new tracks, release.path, :placeholder

      screen.set path

      assert_equal 'Given Artist', release[0].artist
      assert_equal 'Given Title', release[0].title
      assert_equal 1, release[0].number
    end

    def test_continous_mixes_set_mixed_flag_and_va
      release = configure do |release|
        release.mp3 'test'
      end

      path = release.path.join('test.mp3')

      Mp3Track.new path do |mp3|
        mp3.title = 'Continuous Mix'
      end

      tracks = release.tracks

      screen = AddTrackScreen.new tracks, release.path, :placeholder

      screen.set path

      assert release[0].mixed?
      assert_equal 'VA', release[0].artist
    end

    def test_mixed_by_tracks_set_mixed_flag_and_va
      release = configure do |release|
        release.mp3 'test'
      end

      path = release.path.join('test.mp3')

      Mp3Track.new path do |mp3|
        mp3.title = 'Foo (Mixed by Bar)'
      end

      tracks = release.tracks

      screen = AddTrackScreen.new tracks, release.path, :placeholder

      screen.set path

      assert release[0].mixed?
      assert_equal 'VA', release[0].artist
    end
  end
end
