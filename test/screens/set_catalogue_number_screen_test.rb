require_relative '../test_helper'

module Decks
  class SetCatalogueNumberScreenTest < ScreenTestCase
    attr_reader :screen

    def setup
      super

      @screen = SetCatalogueNumberScreen.new release, placeholder
    end

    def test_reads_comma_separated_artists
      screen.set 'GALSOCD 001'

      assert_equal 'GALSOCD 001', release.catalogue_number
    end

    def test_prints_a_useful_prompt
      assert_equal 'Enter catalogue #', screen.prompt
    end
  end
end
