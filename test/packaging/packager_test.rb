require_relative '../test_helper'

module Decks
  class PackagerTest < MiniTest::Unit::TestCase
    class FakeValidator
      def valid?
        true
      end
    end

    class FakeFileNameGenerator

    end

    class NullTagger
      def write_tags(*)

      end
    end

    def package(release, attributes = { })
      values = {
        configuration: release,
        validator: FakeValidator.new,
        file_names: FakeFileNameGenerator.new,
        allowed_files: [ ],
        tagger: NullTagger.new,
        playlists: [ ],
        cue_sheets: [ ],
        logs: [ ]
      }.merge(attributes)

      Packager.new(values).package!
    end

    def test_removes_files_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'foo.txt'
      end

      package release

      refute_file release.path.join('foo.txt')
    end

    def test_removes_directories_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'bar', 'foo.txt'
      end

      package release

      refute_directory release.path.join('bar')
    end

    def test_removes_directory_trees_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'foo', 'bar', 'baz.txt'
      end

      package release

      refute_directory release.path.join('foo', 'bar', 'baz.txt')
    end

    # def test_checks_rules_before_packaging
    #   flunk
    # end

    def refute_file(path)
      refute path.exist?, "#{path} should not exist"
    end

    def refute_directory(path)
      puts Dir[scratch_path.join('**', '*')]

      refute path.directory?, "#{path} should not exist"
    end
  end
end
