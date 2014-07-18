require_relative 'test_helper'

module Decks
  class TrackFileNameFactoryTest < MiniTest::Unit::TestCase
    def build(track, prefix = 'x')
      TrackFileNameFactory.new track, prefix
    end

    def configure(&block)
      configuration = super(&block)
      configuration.tracks.first
    end

    def test_names_is_track_artist_title_group_in_lowercase
      track = configure do |release|
        release.track 'example.mp3' do |track|
          track.number = 1
          track.artist = 'Artist'
          track.title = 'Title'
        end
      end

      factory = build track

      assert_equal 'x01-artist-title-decks.mp3', factory.name
    end

    def test_path_returns_the_complete_pathname_with_new_name
      track = configure do |release|
        release.track 'example.mp3' do |track|
          track.number = 1
          track.artist = 'Artist'
          track.title = 'Title'
        end
      end

      factory = build track

      assert_equal track.path.dirname.join('x01-artist-title-decks.mp3'), factory.path
    end

    def test_can_generate_cue_names
      track = configure do |release|
        release.track 'example.mp3' do |track|
          track.number = 1
          track.artist = 'Artist'
          track.title = 'Title'
        end
      end

      factory = build track

      assert_equal track.path.dirname.join('x01-artist-title-decks.cue'), factory.cue
    end
  end
end
