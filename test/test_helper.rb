require 'bundler/setup'

require 'decks'

require 'minitest/autorun'

class MiniTest::Unit::TestCase
  def working_path
    Pathname.new File.dirname(__FILE__)
  end

  def fixture_path
    working_path.join 'fixtures'
  end

  def scratch_path
    working_path.join 'scratch'
  end

  def setup
    FileUtils.mkdir scratch_path
  end

  def teardown
    FileUtils.rm_rf scratch_path
  end

  def configure(name = 'test')
    release_path = scratch_path.join name
    FileUtils.mkdir_p release_path

    release = Decks::Release.new Decks::Configuration.new(release_path)

    yield Decks::ConfigurationDSL.new(fixture_path, release) if block_given?

    release
  end

  def reconfigure
    yield Decks::ConfigurationDSL.new(fixture_path, release)
    release
  end

  def assert_directory(path)
    assert File.directory?(path), "#{path} should be a directory"
  end

  def assert_release_file(directory, file)
    assert File.exists?(File.join(directory, file)), "#{file} should be in the release"
  end

  def refute_release_file(directory, file)
    refute File.exists?(File.join(directory, file)), "#{file} should not be in the release"
  end

  def read(*paths)
    File.read(File.join(*paths))
  end
end

require_relative 'support/configuration_dsl'
require_relative 'support/screen_test_case'
require_relative 'support/rules_test_case'
