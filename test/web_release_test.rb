require_relative 'test_helper'

module Decks
  class WebReleaseTest < MiniTest::Unit::TestCase
    def test_follows_all_the_general_rules
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
      assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.sfv'
      assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.m3u'

      skip 'cover handling needed'

      assert_release_file release_directory, '00-markus_schulz-city_series-web-(ch238)-2010-decks.jpg'

      assert_release_file release_directory, '01-artist-title-decks.mp3'
    end

    def test_track_information_is_written_into_metadata
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

    def test_compilation_release_are_named_va
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

      assert mp3.compilation?, 'Compilation tag should be set'
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
    end

    def test_track_catalogue_number_is_optional
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

    def test_release_playlist_includes_all_tracks
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

    def test_generates_a_playlist_of_mixed_tracks
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
        release.mp3 'fixture2' do |track|
          track.number = 1
          track.title = 'Unmixed'
          track.artist = 'Artist'
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

    def test_generates_a_playlist_of_unmixed_tracks
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
