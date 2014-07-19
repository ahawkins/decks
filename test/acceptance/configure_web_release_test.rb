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
        'r',
        'q'
      ])

      release_name = 'VA-Ibiza_2006_(Mixed_by_Markus_Schulz)-WEB-2008-DECKS'
      path = scratch_path.join release_name
      assert_path path, 'Package should be created'

      assert_path path.join("00-#{release_name.downcase}.nfo"), 'nfo file missing'
      assert_path path.join("00-#{release_name.downcase}.sfv"), 'sfv file missing'
      assert_path path.join("00-#{release_name.downcase}.m3u"), 'm3u file missing'

      assert_path path.join("01-arnej-they_always_come_back_(original_mix)-decks.mp3")
      assert_path path.join("02-va-continuous_mix_(mixed_by_markus_schulz)-decks.mp3")

      assert_path path.join("00-#{release_name.downcase}-mixed.m3u"), 'mixed m3u file missing'
      assert_path path.join("00-#{release_name.downcase}-unmixed.m3u"), 'mixed m3u file missing'
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

      release_name = 'Markus_Schulz-Without_You_Near-WEB-2008-DECKS'
      path = scratch_path.join release_name
      assert_path path, 'Package should be created'

      assert_path path.join("00-#{release_name.downcase}.nfo"), 'nfo file missing'
      assert_path path.join("00-#{release_name.downcase}.sfv"), 'sfv file missing'
      assert_path path.join("00-#{release_name.downcase}.m3u"), 'm3u file missing'

      assert_path path.join("01-markus_schulz-clear_blue_(ft_elevation)-decks.mp3")

      refute_path path.join("00-#{release_name.downcase}-mixed.m3u"), 'Release is only unmixed'
      refute_path path.join("00-#{release_name.downcase}-unmixed.m3u"), 'Release is only unmixed'
    end

    def test_can_configure_a_release_with_a_catalogue_number
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

      release_name = 'Markus_Schulz-Without_You_Near-(CH005)-WEB-2008-DECKS'
      path = scratch_path.join release_name
      assert_path path, 'Package should be created'

      assert_path path.join("00-#{release_name.downcase}.nfo"), 'nfo file missing'
      assert_path path.join("00-#{release_name.downcase}.sfv"), 'sfv file missing'
      assert_path path.join("00-#{release_name.downcase}.m3u"), 'm3u file missing'

      refute_path path.join("00-#{release_name.downcase}-mixed.m3u"), 'Release is only unmixed'
      refute_path path.join("00-#{release_name.downcase}-unmixed.m3u"), 'Release is only unmixed'
    end

    def test_can_add_a_cue_file_to_a_continous_mix_track
      release = configure 'acceptance_test' do |release|
        release.mp3 '01-continuous_mix'
        release.touch '01-mix.cue' do |cue|
          cue.write 'Fake cue'
        end
      end

      run_script(release, [
        'A', 'Markus Schulz',
        'N', 'Ibiza 2006 (Mixed by Markus Schulz)',
        'C', 'Y',
        'Y', '2008',
        'T',
        'a', '1',
        '1',
        't', 'Continuous Mix (Mixed by Markus Schulz)',
        'a', 'VA',
        'm', 'Y',
        'n', '1',
        'c', '1',
        'b',
        'b',
        'r',
        'q'
      ])

      release_name = 'VA-Ibiza_2006_(Mixed_by_Markus_Schulz)-WEB-2008-DECKS'
      path = scratch_path.join release_name
      assert_path path, 'Package should be created'

      assert_path path.join("00-#{release_name.downcase}.nfo"), 'nfo file missing'
      assert_path path.join("00-#{release_name.downcase}.sfv"), 'sfv file missing'
      assert_path path.join("00-#{release_name.downcase}.m3u"), 'm3u file missing'

      assert_path path.join("01-va-continuous_mix_(mixed_by_markus_schulz)-decks.mp3")
      assert_path path.join("01-va-continuous_mix_(mixed_by_markus_schulz)-decks.cue")
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
