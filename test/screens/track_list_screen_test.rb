require_relative '../test_helper'

module Decks
  class TrackListScreenTest < ScreenTestCase
    def tracks
      release.tracks
    end

    def start
      reconfigure do |release|
        release.tracks.clear

        yield release if block_given?
      end

      screen = TrackListScreen.new release, tracks, placeholder
      router.goto screen
      screen
    end

    def test_prints_the_file_of_each_track
      start do |release|
        release.track 'file1.mp3'
      end

      assert_printed terminal, 'file1.mp3'
    end

    def test_prints_a_choice_for_track
      start do |release|
        release.track 'file1.mp3'
      end

      assert_printed terminal, '( 1)'
    end

    def test_prints_the_title_if_given
      start do |release|
        release.track 'file1.mp3' do |track|
          track.title = 'Given Title'
        end
      end

      assert_printed terminal, 'Given Title'
    end

    def test_prints_the_artist_if_given
      start do |release|
        release.track 'file1.mp3' do |track|
          track.artist = 'Given Artist'
        end
      end

      assert_printed terminal, 'Given Artist'
    end

    def test_tracks_are_oredered_by_number_not_array_position
      start do |release|
        release.track 'file1.mp3' do |track|
          track.number = 2
        end

        release.track 'file2.mp3' do |track|
          track.number = 1
        end
      end

      skip 'How to test this?'
    end

    def test_prints_a_message_if_no_tracks
      start

      assert_printed terminal, 'No Tracks Added'
    end

    def test_goes_back_with_b
      start do |release|
        release.track 'file1.mp3'
      end

      router.input 'b'

      assert_equal placeholder, router.state
    end
  end
end
