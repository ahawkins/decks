require_relative 'test_helper'

module Decks
  class TrackFileNameFactoryTest < MiniTest::Unit::TestCase
    def build
      release = configure do |release|
        yield release
      end

      TrackFileNameFactory.new release.tracks.first
    end

    def test_names_is_track_artist_title_group_in_lowercase
      factory = build do |release|
        release.track 'example.mp3' do |track|
          track.number = 1
          track.artist = 'Artist'
          track.title = 'Title'
        end
      end

      assert_equal '01-artist-title-decks.mp3', factory.name
    end

    def test_can_generate_cue_names
      factory = build do |release|
        release.track 'example.mp3' do |track|
          track.number = 1
          track.artist = 'Artist'
          track.title = 'Title'
        end
      end

      assert_equal '01-artist-title-decks.cue', factory.cue
    end
  end
end
