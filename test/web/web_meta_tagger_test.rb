require_relative '../test_helper'

module Decks
  class WebMetaTaggerTest < MiniTest::Unit::TestCase
    attr_reader :release

    def write(track)
      WebMetaTagger.new(release).write_tags track
    end

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

    def test_writes_total_tracks_to_all_tracks_in_the_release
      tags = write release[0]

      assert_equal tags.total_tracks, release.tracks.size
    end
  end
end
