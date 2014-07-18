require_relative 'test_helper'

module Decks
  class WebReleaseRulesTest < RulesTestCase
    attr_reader :release

    def track
      release.tracks.first
    end

    def setup
      super

      @release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'WEB'

        release.track 'track1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      assert_ok release
    end

    def test_year_is_required
      release.year = nil

      refute_ok release
    end

    def test_artist_is_required
      release.artists = [ ]

      refute_ok release
    end

    def test_name_is_required
      release.name = nil

      refute_ok release
    end

    def test_tracks_are_required
      release.tracks = [ ]

      refute_ok release
    end

    def test_every_track_must_have_a_number
      track.number = nil

      refute_ok release
    end

    def test_every_track_must_have_an_artist
      track.artist = nil

      refute_ok release
    end

    def test_every_track_must_have_a_title
      track.title = nil

      refute_ok release
    end

    def test_same_track_cannot_appear_twice
      @release = configure do |release|
        release.artists = 'Foo'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'WEB'

        release.track 'track1.mp3' do |track|
          track.number = 1
          track.title = 'SF'
          track.artist = 'Foo'
        end

        release.track 'track2.mp3' do |track|
          track.number = 2
          track.title = 'SD'
          track.artist = 'Foo'
        end
      end

      assert_ok release

      reconfigure do |release|
        release[1].number = 1
      end

      refute_ok release
    end

    def test_continuous_mixes_on_compilations_must_be_va
      reconfigure do |release|
        release.compilation = true

        release[0].mixed = true
        release[0].artist = 'foo'
      end

      refute_ok release
    end

    def test_mixed_releases_must_include_the_mixer_in_the_release_name
      reconfigure do |release|
        release.compilation = true
        release.artists = [ 'Foo' ]
        release.name = "City Series (Mixed by Foo)"

        release[0].mixed = true
        release[0].artist = 'VA'
        release[0].title = 'City Series (Mixed by Foo)'
      end

      assert_ok release

      release.name = 'City Series presented by Foo'

      assert_ok release

      release.name = 'City Series'

      refute_ok release
    end

    def test_each_artist_must_be_in_the_track_name_if_compilation
      reconfigure do |release|
        release.compilation = true
        release.artists = [ 'Foo', 'Bar' ]
        release.name = "City Series (Mixed by Foo & Bar)"

        release[0].mixed = true
        release[0].title = 'City Series (Mixed by Foo & Bar)'
        release[0].artist = 'VA'
      end

      assert_ok release

      release.name = 'City Series'

      refute_ok release

      release.name = 'City Series (Mixed by Foo)'

      refute_ok release

      release.name = 'City Series (Mixed by Bar)'

      refute_ok release
    end

    def test_mix_tracks_froms_multi_artist_must_include_an_artist_in_the_title
      @release = configure do |release|
        release.artists = [ 'Foo', 'Bar' ]
        release.name = 'City Series (Mixed by Foo & Bar)'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'WEB'
        release.compilation = true

        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.title = 'SFO (Mixed by Foo)'
          track.artist = 'VA'
          track.mixed = true
        end

        release.track 'cd2.mp3' do |track|
          track.number = 2
          track.title = 'SJC (Mixed by Bar)'
          track.artist = 'VA'
          track.mixed = true
        end
      end

      assert_ok release

      release.tracks[0].title = 'SFO'

      refute_ok release

      release.tracks[0].title = 'SFO (Mixed by Foo)'
      release.tracks[1].title = 'SFO (Mixed by Foo)'

      refute_ok release
    end

    def test_mixed_multi_artist_releases_must_include_each_artist_in_the_release_name
      @release = configure do |release|
        release.artists = [ 'Foo', 'Bar' ]
        release.name = 'City Series (Mixed by Foo & Bar)'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'WEB'
        release.compilation = true

        release.track 'cd1.mp3' do |track|
          track.number = 1
          track.title = 'SFO (Mixed by Foo)'
          track.artist = 'VA'
          track.mixed = true
        end

        release.track 'cd2.mp3' do |track|
          track.number = 2
          track.title = 'SJC (Mixed by Bar)'
          track.artist = 'VA'
          track.mixed = true
        end
      end

      assert_ok release

      release.name = 'City Series (Mixed by Foo)'

      refute_ok release

      release.name = 'City Series (Mixed by Bar)'

      refute_ok release
    end

    def test_mixed_release_names_must_include_continuous_mixes
      reconfigure do |release|
        release.compilation = true
        release.name = 'Test (Mixed by Adam)'

        release[0].mixed = false
      end

      refute_ok release
    end

    def test_mixed_release_name_must_also_be_compilations
      reconfigure do |release|
        release.compilation = false
        release.name = 'Test (Mixed by Adam)'

        release[0].mixed = true
        release[0].artist = 'VA'
      end

      refute_ok release
    end
  end
end
