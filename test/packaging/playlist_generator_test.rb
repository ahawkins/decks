require_relative '../test_helper'

module Decks
  class PlaylistGeneratorTest < MiniTest::Unit::TestCase
    class TestNameGenerator
      def track_file_name(track)
        track.title
      end
    end

    attr_reader :namer

    def build
      release = configure do |release|
        yield release
      end

      PlaylistGenerator.new release.tracks, namer
    end

    def setup
      @namer = TestNameGenerator.new
      super
    end

    def test_use_the_namer_to_create_a_release_playlist
      playlist = build do |release|
        release.track 'track2.mp3' do |track|
          track.title = 'Track2'
          track.number = 2
        end
        release.track 'track1.mp3' do |track|
          track.title = 'Track1'
          track.number = 1
        end
      end

      refute playlist.split?

      list = playlist.all_files

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track2'
    end

    def test_uses_the_namer_to_create_a_mixed_playlist
      playlist = build do |release|
        release.track 'track2.mp3' do |track|
          track.title = 'Track2'
          track.number = 2
        end
        release.track 'track1.mp3' do |track|
          track.title = 'Track1'
          track.number = 1
          track.mixed = true
        end
        release.track 'track2.mp3' do |track|
          track.title = 'Track3'
          track.number = 3
          track.mixed = true
        end
      end

      assert playlist.split?

      list = playlist.mixed_files

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track3'
    end

    def test_uses_the_namer_to_crate_an_unmixed_playlist
      playlist = build do |release|
        release.track 'track2.mp3' do |track|
          track.title = 'Track2'
          track.number = 2
          track.mixed = true
        end
        release.track 'track1.mp3' do |track|
          track.title = 'Track1'
          track.number = 1
          track.mixed = false
        end
        release.track 'track2.mp3' do |track|
          track.title = 'Track3'
          track.number = 3
          track.mixed = false
        end
      end

      assert playlist.split?

      list = playlist.unmixed_files

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track3'
    end
  end
end
