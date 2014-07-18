require_relative 'test_helper'

module Decks
  class CdReleaseTest < MiniTest::Unit::TestCase
    include PackagingTests

    def test_release_name_follows_proper_format
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'

      assert_directory release_directory
    end

    def test_creates_a_sfv_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '000-markus_schulz-city_series-cd-(ch238)-2010-decks.sfv'
    end

    def test_creates_a_nfo_file
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '000-markus_schulz-city_series-cd-(ch238)-2010-decks.nfo'
    end

    def test_single_jpg_in_directory_is_used_for_cover
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.image 'cover.jpg'
        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '000-markus_schulz-city_series-cd-(ch238)-2010-decks.jpg'
    end

    def test_compilation_releases_are_named_va
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'CD'
        release.compilation = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'VA-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory
    end

    def test_audio_files_are_named_number_artist_title_group
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.compilation = false
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '101-artist-title-decks.mp3'
    end

    def test_album_release_information_is_written_to_each_track
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.compilation = false
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '101-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '101-artist-title-decks.mp3')

      assert_equal 'Artist', mp3.artist
      assert_equal 'Title', mp3.title

      assert_equal release.name, mp3.album
      assert_equal 'Markus Schulz', mp3.album_artist

      assert_equal 1, mp3.track
      assert_equal 1, mp3.total_tracks

      assert_equal 1, mp3.disc
      assert_equal 1, mp3.total_discs

      assert_equal release.year, mp3.year

      refute mp3.compilation?, 'Should not be a compilation'
    end

    def test_compilation_release_information_is_written_to_each_track
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.compilation = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'VA-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '101-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '101-artist-title-decks.mp3')

      assert_equal 'Artist', mp3.artist
      assert_equal 'Title', mp3.title

      assert_equal release.name, mp3.album
      assert_equal 'Markus Schulz', mp3.album_artist

      assert_equal 1, mp3.track
      assert_equal 1, mp3.total_tracks

      assert_equal 1, mp3.disc
      assert_equal 1, mp3.total_discs

      assert_equal release.year, mp3.year

      assert mp3.compilation?, 'Should be a compilation'
    end

    def test_catalogue_number_is_optional
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.image 'cover.jpg'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '000-markus_schulz-city_series-cd-2010-decks.nfo'
      assert_release_file release_directory, '000-markus_schulz-city_series-cd-2010-decks.sfv'
      assert_release_file release_directory, '000-markus_schulz-city_series-cd-2010-decks.m3u'
      assert_release_file release_directory, '000-markus_schulz-city_series-cd-2010-decks.jpg'
    end

    def test_does_not_break_if_released_twice
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      2.times { release.release! }

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory
    end

    def test_handles_multiple_artist_releases
      release = configure do |release|
        release.artists = [ 'Fleming', 'Lawrence ']
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Fleming_and_Lawrence-City_Series-CD-(CH238)-2010-DECKS'
      assert_directory release_directory

      assert_release_file release_directory, '101-artist-title-decks.mp3'

      mp3 = AudioFile.new File.join(release_directory, '101-artist-title-decks.mp3')

      assert_equal 'Fleming & Lawrence', mp3.album_artist
    end

    def test_generates_a_playlist_for_all_files_in_the_release
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Track A'
          track.artist = 'DJ'
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.disc = 1
          track.title = 'Track b'
          track.artist = 'DJ'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-2010-DECKS'
      assert_directory release_directory

      playlist_file = '000-markus_schulz-city_series-cd-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 2, playlist.size
      assert_equal '101-dj-track_a-decks.mp3', playlist[0]
      assert_equal '102-dj-track_b-decks.mp3', playlist[1]
    end

    def test_generates_an_unmixed_playlist_if_there_are_unmixed_and_mixed_files
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Track A'
          track.artist = 'DJ'
          track.mixed = false
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.disc = 1
          track.title = 'Track b'
          track.artist = 'DJ'
          track.mixed = true
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-2010-DECKS'
      assert_directory release_directory

      playlist_file = '000-markus_schulz-city_series_(unmixed)-cd-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 1, playlist.size
      assert_equal '101-dj-track_a-decks.mp3', playlist[0]
    end

    def test_does_not_generate_an_unmixed_playlist_if_only_unmixed_tracks
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.disc = 1
          track.title = 'Track b'
          track.artist = 'DJ'
          track.mixed = true
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-2010-DECKS'
      assert_directory release_directory

      playlist_file = '000-markus_schulz-city_series_(unmixed)-cd-2010-decks.m3u'
      refute_release_file release_directory, playlist_file
    end

    def test_generates_a_mixed_playlist_if_there_are_unmixed_and_mixed_files
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Track A'
          track.artist = 'DJ'
          track.mixed = false
        end
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.disc = 1
          track.title = 'Track b'
          track.artist = 'DJ'
          track.mixed = true
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-2010-DECKS'
      assert_directory release_directory

      playlist_file = '000-markus_schulz-city_series_(continuous_mixes)-cd-2010-decks.m3u'
      assert_release_file release_directory, playlist_file

      playlist = read(release_directory, playlist_file).split

      assert_equal 1, playlist.size
      assert_equal '102-dj-track_b-decks.mp3', playlist[0]
    end

    def test_does_not_generate_a_mixed_playlist_if_only_mixed_tracks
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.format = 'cd'
        release.track 'fixture2.mp3' do |track|
          track.number = 2
          track.disc = 1
          track.title = 'Track b'
          track.artist = 'DJ'
          track.mixed = true
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-2010-DECKS'
      assert_directory release_directory

      playlist_file = '000-markus_schulz-city_series_(continuous_mixes)-cd-2010-decks.m3u'
      refute_release_file release_directory, playlist_file
    end

    # def test_writes_a_cue_file_for_tracks
    #   release = configure do |release|
    #     release.artist = 'Markus Schulz'
    #     release.name = 'City Series'
    #     release.year = 2010
    #     release.catalogue_number = 'CH238'
    #     release.format = 'cd'
    #     release.cover 'cover'
    #     release.track 'fixture1.mp3' do |track|
    #       track.number = 1
    #       track.disc = 1
    #       track.title = 'Title'
    #       track.artist = 'Artist'
    #       track.cue = 'fake cue'
    #     end
    #   end
    #
    #   release.release!
    #
    #   release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
    #   assert_directory release_directory
    #
    #   cue_file = '101-artist-title-decks.cue'
    #   assert_release_file release_directory, cue_file
    #
    #   cue = read release_directory, cue_file
    #   assert_equal 'fake cue', cue
    # end
    #
    # def test_writes_a_log_file_for_tracks
    #   release = configure do |release|
    #     release.artist = 'Markus Schulz'
    #     release.name = 'City Series'
    #     release.year = 2010
    #     release.catalogue_number = 'CH238'
    #     release.format = 'cd'
    #     release.cover 'cover'
    #     release.track 'fixture1.mp3' do |track|
    #       track.number = 1
    #       track.disc = 1
    #       track.title = 'Title'
    #       track.artist = 'Artist'
    #       track.log = 'fake log'
    #     end
    #   end
    #
    #   release.release!
    #
    #   release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
    #   assert_directory release_directory
    #
    #   log_file = '101-artist-title-decks.log'
    #   assert_release_file release_directory, log_file
    #
    #   log = read release_directory, log_file
    #   assert_equal 'fake log', log
    # end
    #
    # def test_creates_a_playlist_for_each_disc
    #   release = configure do |release|
    #     release.artist = 'Markus Schulz'
    #     release.name = 'City Series'
    #     release.year = 2010
    #     release.catalogue_number = 'CH238'
    #     release.format = 'cd'
    #     release.cover 'cover'
    #     release.track 'fixture1.mp3' do |track|
    #       track.number = 1
    #       track.disc = 1
    #       track.title = 'Title'
    #       track.artist = 'Artist'
    #       track.cue = 'fake cue'
    #     end
    #     release.track 'fixture2.mp3' do |track|
    #       track.number = 1
    #       track.disc = 2
    #       track.title = 'Title'
    #       track.artist = 'Artist'
    #       track.cue = 'fake cue'
    #     end
    #   end
    #
    #   release.release!
    #
    #   release_directory = scratch_path.join 'Markus_Schulz-City_Series-CD-(CH238)-2010-DECKS'
    #   assert_directory release_directory
    #
    #   playlist_file = '100-markus_schulz-city_series-cd-(ch238)-2010-decks.m3u'
    #   assert_release_file release_directory, playlist_file
    #
    #   playlist = read(release_directory, playlist_file).split
    #
    #   assert_equal 1, playlist.size
    #   assert_includes playlist, '101-artist-title-decks.mp3'
    # end

    def test_files_not_configured_are_deleted
      release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.touch 'foo.txt'
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Markus_Schulz-City_Series-cd-(CH238)-2010-DECKS'
      assert_directory release_directory

      refute_release_file release_directory, 'foo.txt'
    end

    def test_handles_lossless_releases
      release = configure do |release|
        release.artists = [ 'Fleming', 'Lawrence ']
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'cd'
        release.image 'cover.jpg'
        release.lossless = true
        release.track 'fixture1.mp3' do |track|
          track.number = 1
          track.disc = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      release.release!

      release_directory = scratch_path.join 'Fleming_and_Lawrence-City_Series-CD-(CH238)-LOSSLESS-2010-DECKS'
      assert_directory release_directory

      assert_release_file release.path, '000-fleming_and_lawrence-city_series-cd-(ch238)-lossless-2010-decks.nfo'
      assert_release_file release.path, '000-fleming_and_lawrence-city_series-cd-(ch238)-lossless-2010-decks.sfv'
      assert_release_file release.path, '000-fleming_and_lawrence-city_series-cd-(ch238)-lossless-2010-decks.m3u'
      assert_release_file release.path, '000-fleming_and_lawrence-city_series-cd-(ch238)-lossless-2010-decks.jpg'
    end
  end
end
