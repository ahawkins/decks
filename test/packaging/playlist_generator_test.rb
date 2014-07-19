require_relative '../test_helper'

module Decks
  class PlaylistGeneratorTest < MiniTest::Unit::TestCase
    class FakeFileNameGenerator
      def track(track)
        track.title
      end

      def playlist
        'all_files.m3u'
      end

      def mixed_playlist
        'mixed.m3u'
      end

      def unmixed_playlist
        'unmixed.m3u'
      end
    end

    attr_reader :file_names

    def build
      release = configure do |release|
        yield release
      end

      PlaylistGenerator.new release.tracks, file_names
    end

    def setup
      @file_names = FakeFileNameGenerator.new
      super
    end

    def test_use_the_namer_to_create_a_release_playlist
      playlists = build do |release|
        release.track 'track2.mp3' do |track|
          track.title = 'Track2'
          track.number = 2
        end
        release.track 'track1.mp3' do |track|
          track.title = 'Track1'
          track.number = 1
        end
      end

      assert_equal 1, playlists.count, 'Should only be a release playlist if no mixed & unmixed tracks'

      list = playlists.release

      assert_includes playlists, list, 'List should be in release'

      assert_equal file_names.playlist, list.name

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track2'
    end

    def test_uses_the_namer_to_create_a_mixed_playlist
      playlists = build do |release|
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

      assert_equal 3, playlists.count, 'Should be release/mixed/unmixed playlists'

      list = playlists.mixed

      assert_includes playlists, list, 'List should be in release'

      assert_equal file_names.mixed_playlist, list.name

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track3'
    end

    def test_uses_the_namer_to_create_an_unmixed_playlist
      playlists = build do |release|
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

      assert_equal 3, playlists.count, 'Should be release/mixed/unmixed playlists'

      list = playlists.unmixed

      assert_includes playlists, list, 'List should be in release'

      assert_equal file_names.unmixed_playlist, list.name

      assert_equal 2, list.size

      assert_equal list[0], 'Track1'
      assert_equal list[1], 'Track3'
    end
  end
end
