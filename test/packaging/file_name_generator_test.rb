require_relative '../test_helper'

module Decks
  class FileNameGeneratorTest < MiniTest::Unit::TestCase
    def build(release)
      FileNameGenerator.new release
    end

    def test_follows_the_proper_format
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal 'Artist-Album-CD-2014-DECKS', factory.release
    end

    def test_compilation_releases_are_named_va
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.compilation = true
      end

      factory = build release

      assert_equal 'VA-Album-CD-2014-DECKS', factory.release
    end

    def test_handles_multiple_artist_names
      release = configure do |release|
        release.artists = [ 'Artist1', 'Artist2' ]
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.compilation = false
      end

      factory = build release

      assert_equal 'Artist1_and_Artist2-Album-CD-2014-DECKS', factory.release
    end

    def test_works_with_catalogue_number
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.catalogue_number = '1234'
      end

      factory = build release

      assert_equal 'Artist-Album-(1234)-CD-2014-DECKS', factory.release
    end

    def test_works_with_losess_releases
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
      end

      factory = build release

      assert_equal 'Artist-Album-CD-LOSSLESS-2014-DECKS', factory.release
    end

    def test_works_with_lossless_and_catalogue_numbers
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
        release.catalogue_number = '1234'
      end

      factory = build release

      assert_equal 'Artist-Album-(1234)-CD-LOSSLESS-2014-DECKS', factory.release
    end

    def test_can_generate_nfo_file_names
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}.nfo", factory.nfo
    end

    def test_can_generate_cover_file_names
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}.jpg", factory.cover
    end

    def test_can_generate_proof_jpg_file_names
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}-proof.jpg", factory.proof
    end

    def test_can_generate_sfv_file_names
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}.sfv", factory.sfv
    end

    def test_can_generate_m3u_file_names
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}.m3u", factory.playlist
    end

    def test_can_generate_unmixed_m3u_filenames
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}-unmixed.m3u", factory.unmixed_playlist
    end

    def test_can_generate_continuous_mixes_m3u_filenames
      release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      factory = build release

      assert_equal "#{factory.release.downcase}-mixed.m3u", factory.mixed_playlist
    end
  end
end
