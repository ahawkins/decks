require_relative 'test_helper'

module Decks
  class WebReleaseTest < MiniTest::Unit::TestCase
    include PackagingTests

    def test_release_name_follows_proper_format
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory
    end

    def test_creates_an_sfv_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.sfv'
    end

    def test_creates_a_nfo_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.nfo'
    end

    def test_audio_files_are_named_number_artist_title_group
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.compilation = false
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '01-artist-title-decks.mp3'
    end

    def test_album_release_information_is_written_to_each_track
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.compilation = false
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '01-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '01-artist-title-decks.mp3')

      assert_equal 'Artist', mp3.artist
      assert_equal 'Title', mp3.title

      assert_equal release.name, mp3.album
      assert_equal 'Markus Schulz', mp3.album_artist

      assert_equal 1, mp3.track
      assert_equal 1, mp3.total_tracks

      assert_equal release.year, mp3.year

      refute mp3.compilation?, 'Compilation tag should not be set'
    end

    def test_compilation_releases_are_named_va
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.compilation = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'VA-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory
    end

    def test_compilation_release_information_is_written_to_each_track
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.compilation = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'VA-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '01-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '01-artist-title-decks.mp3')

      assert_equal 'Artist', mp3.artist
      assert_equal 'Title', mp3.title

      assert_equal release.name, mp3.album
      assert_equal 'Markus Schulz', mp3.album_artist

      assert_equal 1, mp3.track
      assert_equal 1, mp3.total_tracks

      assert_equal release.year, mp3.year

      assert mp3.compilation?, 'Compilation tag should be set'
    end

    def test_generates_a_playlist_for_all_files_in_the_release
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.title = 'Unmixed'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      playlist_file = '00-markus_schulz-city_series-web-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 2, playlist.size
      assert_equal '01-va-mixed-decks.mp3', playlist[0]
      assert_equal '02-artist-unmixed-decks.mp3', playlist[1]
    end

    def test_generates_a_mixed_playlist_if_there_are_unmixed_and_mixed_files
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.title = 'Unmixed'
          track.artist = 'Artist'
          track.mixed = false
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      playlist_file = '00-markus_schulz-city_series_(continuous_mixes)-web-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 1, playlist.size
      assert_includes playlist, '01-va-mixed-decks.mp3'
    end

    def test_does_not_generate_a_mixed_playlist_if_only_mixed_tracks
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      playlist_file = '00-markus_schulz-city_series_(continuous_mixes)-web-2010-decks.m3u'
      refute_release_file release_directory, playlist_file
    end

    def test_generates_an_unmixed_playlist_if_there_are_unmixed_and_mixed_files
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.title = 'Unmixed'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      playlist_file = '00-markus_schulz-city_series_(unmixed)-web-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 1, playlist.size
      assert_includes playlist, '02-artist-unmixed-decks.mp3'
    end

    def test_does_not_generate_an_unmixed_playlist_if_only_unmixed_tracks
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Foo (Original Mix)'
          track.artist = 'Bar'
          track.mixed = false
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      playlist_file = '00-markus_schulz-city_series_(unmixed)-web-2010-decks.m3u'
      refute_release_file release_directory, playlist_file
    end

    # def test_follows_all_the_general_rules
    #   release = configure do |release|
    #     release.artist = 'Markus Schulz'
    #     release.name = 'City Series'
    #     release.year = 2010
    #     release.catalogue_number = 'CH238'
    #     release.format = 'web'
    #     release.cover 'cover'
    #     release.track 'fixture1.mp3' do |track|
    #       track.number = 1
    #       track.title = 'Title'
    #       track.artist = 'Artist'
    #     end
    #   end
    #
    #   release.release!
    #
    #   release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
    #   assert_directory release_directory
    #
    #   assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.nfo'
    #   assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.sfv'
    #   assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.m3u'
    #
    #   skip 'cover handling needed'
    #
    #   assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.jpg'
    #
    #   assert_release_file release_directory, '01-artist-title-decks.mp3'
    # end

    def test_does_not_break_if_released_twice
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      2.times { release.release! }

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory
    end

    def test_handles_multiple_artist_releases
      release = configure do |release|
        release.artists = [ 'Fleming', 'Lawrence ']
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Fleming_and_Lawrence-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '01-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '01-artist-title-decks.mp3')

      assert_equal 'Fleming & Lawrence', mp3.album_artist
    end

    def test_handles_lossless_releases
      release = configure do |release|
        release.artists = [ 'Fleming', 'Lawrence ']
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.lossless = true
        release.mp3 'fixture1' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Fleming_and_Lawrence-City_Series-WEB-(CH238)-LOSSLESS-2010-DECKS'
      assert_directory release_directory

      assert_release_file release.path, '00-fleming_and_lawrence-city_series-web-(ch238)-lossless-2010-decks.nfo'
      assert_release_file release.path, '00-fleming_and_lawrence-city_series-web-(ch238)-lossless-2010-decks.sfv'
      assert_release_file release.path, '00-fleming_and_lawrence-city_series-web-(ch238)-lossless-2010-decks.m3u'

      skip 'Cover handling required'

      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.jpg'
    end

    def test_catalogue_number_is_optional
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.nfo'
      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.sfv'
      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.m3u'

      skip 'Cover handling required'

      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.jpg'
    end

    def test_writes_a_cue_file_if_provided
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
        release.cover 'cover'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
          track.cue = 'fake cue'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      cue_file = '01-va-mixed-decks.cue'
      assert_release_file release_directory, cue_file

      cue = read release_directory, cue_file
      assert_equal 'fake cue', cue
    end

    def test_files_not_configured_are_deleted
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.cover 'cover'
        release.touch 'foo.txt'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-(CH238)-2010-DECKS'
      assert_directory release_directory

      refute_release_file release_directory, 'foo.txt'
    end
  end
end
