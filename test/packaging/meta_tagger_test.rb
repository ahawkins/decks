require_relative '../test_helper'

module Decks
  class MetaTaggerTest < MiniTest::Unit::TestCase
    attr_reader :release

    def setup
      @release = configure do |release|
        release.artist = 'Artist'
        release.name = 'Name'
        release.year = 2014
        release.track 'example.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Track Artist'
        end
      end
    end

    def write(track)
      MetaTagger.new(release).write_tags track
    end

    def test_sets_the_track_number
      tags = write release[0]

      assert_equal release[0].number, tags.track
    end

    def test_sets_the_title
      tags = write release[0]

      assert_equal release[0].title, tags.title
    end

    def test_sets_the_album_to_the_release_name
      tags = write release[0]

      assert_equal release.name, tags.album
    end

    def test_sets_the_year_to_the_release_year
      tags = write release[0]

      assert_equal release.year, tags.year
    end

    def test_sets_the_compilation_flag
      release.compilation = true

      tags = write release[0]

      assert tags.compilation?
    end

    def test_sets_album_artist_to_release_artists
      tags = write release[0]

      assert_equal release.artists.first, tags.album_artist
    end

    def test_multiple_release_artists_are_written_to_album_artist
      release.artists = [ 'Foo', 'Bar' ]
      tags = write release[0]

      assert_equal 'Foo & Bar', tags.album_artist
    end
  end
end
