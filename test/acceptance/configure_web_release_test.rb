require_relative '../test_helper'
require 'stringio'

module Decks
  class ConfigureWebReleaseTest < MiniTest::Unit::TestCase
    class ScriptedInput
      include Concord.new(:inputs)

      def gets
        if inputs.empty?
          throw :done
        else
          inputs.shift
        end
      end
    end

    def run_script(release, commands)
      release.format = 'WEB'
      UI.start release, StringIO.new, ScriptedInput.new(commands)
    end

    def test_can_configure_a_compilation_web_release
      release = configure 'acceptance_test' do |release|
        release.format = 'WEB'
        release.mp3 '01-test'
        release.mp3 '02-continuous_mix'
      end

      run_script(release, [
        'A', 'Markus Schulz',
        'N', 'Ibiza 2006 (Mixed by Markus Schulz)',
        'C', 'Y',
        'Y', '2008',
        'L', 'Coldharbor',
        '#', 'CH005',
        'T',
        'a', '1',
        '1',
        'a', 'Arnej',
        't', 'They Always Come Back (Original Mix)',
        'n', '1',
        'b',
        'a', '2',
        '2',
        't', 'Continuous Mix (Mixed by Markus Schulz)',
        'a', 'VA',
        'm', 'Y',
        'n', '2',
        'b',
        'b',
        'r'
      ])

      assert_equal [ 'Markus Schulz' ], release.artists
      assert_equal 'Ibiza 2006 (Mixed by Markus Schulz)', release.name
      assert release.compilation?
      assert_equal 2008, release.year
      assert_equal 'Coldharbor', release.label
      assert_equal 'CH005', release.catalogue_number

      assert_equal 2, release.tracks.size

      assert_equal 'Arnej', release[0].artist
      assert_equal 'They Always Come Back (Original Mix)', release[0].title
      assert_equal 1, release[0].number

      assert_equal 'VA', release[1].artist
      assert_equal 'Continuous Mix (Mixed by Markus Schulz)', release[1].title
      assert_equal 2, release[1].number
      assert release[1].mixed?

      assert_directory scratch_path.join('VA-Ibiza_2006_(Mixed_by_Markus_Schulz)-WEB-(CH005)-2008-DECKS')
    end

    def test_can_configure_an_album_web_release
      release = configure 'acceptance_test' do |release|
        release.format = 'WEB'
        release.mp3 '01-test'
      end

      run_script(release, [
        'A', 'Markus Schulz',
        'N', 'Without You Near',
        'C', 'N',
        'Y', '2008',
        'L', 'Coldharbor',
        '#', 'CH005',
        'T',
        'a', '1',
        '1',
        'a', 'Markus Schulz',
        't', 'Clear Blue (ft Elevation)',
        'n', '1',
        'b',
        'b',
        'r'
      ])

      assert_equal [ 'Markus Schulz' ], release.artists
      assert_equal 'Without You Near', release.name
      refute release.compilation?
      assert_equal 2008, release.year
      assert_equal 'Coldharbor', release.label
      assert_equal 'CH005', release.catalogue_number

      assert_equal 1, release.tracks.size

      assert_equal 'Markus Schulz', release[0].artist
      assert_equal 'Clear Blue (ft Elevation)', release[0].title
      assert_equal 1, release[0].number
      refute release[0].mixed?

      assert_directory scratch_path.join('Markus_Schulz-Without_You_Near-WEB-(CH005)-2008-DECKS')
    end

    def test_can_configure_a_cue_file_for_a_track
      release = configure 'acceptance_test' do |release|
        release.mp3 '01-continuous_mix'
        release.touch '01-mix.cue', 'fake cue'
      end

      run_script(release, [
        'T',
        'a', '1',
        '1',
        'c', '1'
      ])

      assert_equal 1, release.tracks.size
      assert_equal 'fake cue', release[0].cue
    end

    def test_can_change_the_file_for_an_existing_track
      release = configure 'acceptance_test' do |release|
        release.mp3 '01-file1'
        release.mp3 '02-file2'
      end

      run_script(release, [
        'T',
        'a', '1',
        '1',
        'f', '2'
      ])

      assert_equal 1, release.tracks.size

      assert_equal release.path.join('02-file2.mp3'), release[0].path
    end
  end
end
