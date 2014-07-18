require_relative 'test_helper'

module Decks
  class WebReleaseTest < MiniTest::Unit::TestCase
    def test_creates_a_sfv_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      assert release.sfv, 'No SFV generated'
    end

    def test_creates_a_nfo_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'web'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      assert release.nfo, 'No NFO generated'
    end

    def test_single_jpg_in_directory_is_used_for_cover
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'web'
        release.image 'cover.jpg'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-WEB-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '00-markus_schulz-city_series-web-2010-decks.jpg'
    end

    def test_album_release_information_is_written_to_each_track
      release = configure do |release|
        release.artists = [ 'Fleming', 'Lawrence' ]
        release.name = 'City Series'
        release.year = 2010
        release.format = 'web'
        release.compilation = false
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      mp3 = AudioFile.new release.grep(/mp3/)

      assert_equal 'Artist', mp3.artist
      assert_equal 'Title', mp3.title

      assert_equal release.name, mp3.album
      assert_equal 'Fleming & Lawrence', mp3.album_artist

      assert_equal 1, mp3.track
      assert_equal 1, mp3.total_tracks

      assert_equal release.year, mp3.year

      refute mp3.compilation?, 'Compilation tag should not be set'
    end

    def test_compilation_release_information_is_written_to_each_track
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'web'
        release.compilation = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      mp3 = AudioFile.new release.grep(/mp3/)

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

      playlist = read(release.playlist).split

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

      playlist = read(release.mixed_playlist).split

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
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Mixed'
          track.artist = 'VA'
          track.mixed = true
        end
      end

      release.release!

      refute release.mixed_playlist, 'Mixed playlist should not exist'
    end

    def test_generates_an_unmixed_playlist_if_there_are_unmixed_and_mixed_files
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.compilation = false
        release.format = 'web'
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

      playlist = File.read(release.unmixed_playlist).split

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
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Foo (Original Mix)'
          track.artist = 'Bar'
          track.mixed = false
        end
      end

      release.release!

      refute release.unmixed_playlist, 'Unmixed playlist should not exist'
    end

    def test_does_not_break_if_released_twice
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'web'
        release.image 'cover.jpg'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      2.times { release.release! }
    end

    def test_files_not_configured_are_deleted
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'web'
        release.touch 'foo.txt'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      assert_empty release.glob('foo.txt'), 'Junk files should be deleted'
    end

    def read(pathname)
      File.read pathname
    end
  end
end
