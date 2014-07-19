require_relative '../test_helper'

module Decks
  class WebFileNameGeneratorTest < MiniTest::Unit::TestCase
    class FakeDelegate
      def release
        'fake-release'
      end

      def nfo
        'fake.nfo'
      end

      def sfv
        'fake.sfv'
      end

      def cover
        'cover.jpg'
      end

      def playlist
        'playlist.m3u'
      end

      def mixed_playlist
        'mixed.m3u'
      end

      def unmixed_playlist
        'unmixed.mp3'
      end

      def proof
        'proof.jpg'
      end

      def track(t)
        "#{t.title}#{t.path.extname}"
      end
    end

    attr_reader :delegate, :file_names

    def setup
      @delegate = FakeDelegate.new
      @file_names = WebFileNameGenerator.new delegate
    end

    def test_does_not_change_release
      assert_equal delegate.release, file_names.release
    end

    def test_prepends_00_to_nfo
      assert_equal "00-#{delegate.nfo}", file_names.nfo
    end

    def test_prepends_00_to_sfv
      assert_equal "00-#{delegate.sfv}", file_names.sfv
    end

    def test_prepends_00_to_cover
      assert_equal "00-#{delegate.cover}", file_names.cover
    end

    def test_prepends_00_to_playlist
      assert_equal "00-#{delegate.playlist}", file_names.playlist
    end

    def test_prepends_00_to_mixed_playlist
      assert_equal "00-#{delegate.mixed_playlist}", file_names.mixed_playlist
    end

    def test_prepends_00_to_unmixed_playlist
      assert_equal "00-#{delegate.unmixed_playlist}", file_names.unmixed_playlist
    end

    def test_prepends_00_to_proof
      assert_equal "00-#{delegate.proof}", file_names.proof
    end

    def test_cue_sheet_names_are_the_same_as_track_names
      release = configure do |release|
        release.track 'test.mp3' do |track|
          track.title = 'test'
        end
      end

      assert_equal 'test.cue', file_names.cue(release[0])
    end
  end
end
