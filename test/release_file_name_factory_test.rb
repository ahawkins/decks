require_relative 'test_helper'

module Decks
  class ReleaseFileNameFactoryTest < MiniTest::Unit::TestCase
    def build
      release = configure do |release|
        yield release
      end

      ReleaseFileNameFactory.new release
    end

    def test_follows_the_proper_format
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal 'Artist-Album-CD-2014-DECKS', factory.name
    end

    def test_compilation_releases_are_named_va
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.compilation = true
      end

      assert_equal 'VA-Album-CD-2014-DECKS', factory.name
    end

    def test_handles_multiple_artist_names
      factory = build do |release|
        release.artists = [ 'Artist1', 'Artist2' ]
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.compilation = false
      end

      assert_equal 'Artist1_and_Artist2-Album-CD-2014-DECKS', factory.name
    end

    def test_works_with_catalogue_number
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.catalogue_number = '1234'
      end

      assert_equal 'Artist-Album-(1234)-CD-2014-DECKS', factory.name
    end

    def test_works_with_losess_releases
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
      end

      assert_equal 'Artist-Album-CD-LOSSLESS-2014-DECKS', factory.name
    end

    def test_works_with_lossless_and_catalogue_numbers
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
        release.catalogue_number = '1234'
      end

      assert_equal 'Artist-Album-(1234)-CD-LOSSLESS-2014-DECKS', factory.name
    end

    def test_name_can_be_given_extra_tags
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
        release.catalogue_number = '1234'
      end

      assert_equal 'Artist-Album-(1234)-TAG1-TAG2-CD-LOSSLESS-2014-DECKS', factory.name('TAG1', 'TAG2')
    end

    def test_name_tags_are_in_all_caps
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
        release.catalogue_number = '1234'
      end

      assert_equal 'Artist-Album-(1234)-TAG1-TAG2-CD-LOSSLESS-2014-DECKS', factory.name(:tag1, :tag2)
    end

    def test_filename_is_release_name_in_lowercase
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal factory.name.downcase, factory.file
    end

    def test_file_names_can_be_given_extra_tags
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
        release.lossless = true
        release.catalogue_number = '1234'
      end

      assert_equal factory.name('TAG').downcase, factory.file('TAG')
    end

    def test_can_generate_nfo_file_names
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name.downcase}.nfo", factory.nfo
    end

    def test_can_generate_jpg_file_names
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name.downcase}.jpg", factory.jpg
    end

    def test_can_generate_proof_jpg_file_names
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name('PROOF').downcase}.jpg", factory.proof
    end

    def test_can_generate_sfv_file_names
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name.downcase}.sfv", factory.sfv
    end

    def test_can_generate_m3u_file_names
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name.downcase}.m3u", factory.m3u
    end

    def test_can_generate_unmixed_m3u_filenames
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name('UNMIXED').downcase}.m3u", factory.unmixed_m3u
    end

    def test_can_generate_continuous_mixes_m3u_filenames
      factory = build do |release|
        release.artist = 'Artist'
        release.name = 'Album'
        release.year = 2014
        release.format = 'CD'
      end

      assert_equal "#{factory.name('MIXED').downcase}.m3u", factory.mixed_m3u
    end
  end
end
