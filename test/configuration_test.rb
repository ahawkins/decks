require_relative 'test_helper'

module Decks
  class ConfigurationTest < MiniTest::Unit::TestCase
    def test_chops_off_trailing_slash_when_initialized
      configuration = Configuration.new Pathname.new('/foo/bar/')
      assert_equal Pathname.new('/foo/bar'), configuration.path

      configuration = Configuration.new Pathname.new('\\foo\bar\\')
      assert_equal Pathname.new('\\foo\\bar'), configuration.path
    end

    def test_can_be_initialized_with_a_string
      configuration = Configuration.new '/foo/bar'
      assert_equal Pathname.new('/foo/bar'), configuration.path
    end
  end
end
