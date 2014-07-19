require_relative '../test_helper'

module Decks
  class PackagerTest < MiniTest::Unit::TestCase
    class FakeValidator
      def valid?
        true
      end
    end

    class FakeFileNameGenerator
      def release
        'Packaging-Tests-RB-2014-ADAM'
      end

      def nfo
        'fake.nfo'
      end

      def sfv
        'fake.sfv'
      end

      def track(track)
        "#{track.title}#{track.path.extname}"
      end

      def cover
        'fake.jpg'
      end
    end

    class NullTagger
      def write_tags(*)

      end
    end

    FakeFile = Struct.new :name, :content
    FakeImage = Struct.new :path, :name

    def package(release, attributes = { })
      values = {
        configuration: release,
        validator: FakeValidator.new,
        file_names: FakeFileNameGenerator.new,
        tagger: NullTagger.new,
        images: [ ],
        playlists: [ ],
        cue_sheets: [ ],
        logs: [ ],
      }.merge(attributes)

      Packager.new(values).package!
    end

    def test_checks_rules_before_packaging
      klass = Class.new do
        def valid?
          false
        end

        def errors
          'Everything!'
        end
      end

      assert_raises Packager::PackageError do
        package configure, validator: klass.new
      end
    end

    def test_removes_files_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'foo.txt'
      end

      package release

      refute_path release.path.join('foo.txt')
    end

    def test_removes_directories_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'bar', 'foo.txt'
      end

      package release

      refute_path release.path.join('bar')
    end

    def test_removes_directory_trees_not_in_the_allowed_list
      release = configure do |release|
        release.touch 'foo', 'bar', 'baz.txt'
      end

      package release

      refute_path release.path.join('foo', 'bar', 'baz.txt')
    end

    def test_writes_tags_for_each_track_in_the_release
      klass = Class.new do
        def initialize
          @written = [ ]
        end

        def written
          @written
        end

        def write_tags(track)
          @written << track
        end
      end

      release = configure do |release|
        release.track 'example.mp3' do |track|
          track.title = 'tag_writing'
        end
      end

      tagger = klass.new

      package release, tagger: tagger

      assert_includes tagger.written, release[0]
    end

    def test_creates_an_nfo_file_using_the_generated_file_name
      file_names = FakeFileNameGenerator.new

      release = configure

      package release, file_names: file_names

      assert_path release.path.join(file_names.nfo)
    end

    def test_tracks_are_renamed_according_to_the_generated_file_names
      file_names = FakeFileNameGenerator.new

      release = configure do |release|
        release.track 'example.mp3' do |track|
          track.title = 'renaming_test'
        end
      end

      package release, file_names: file_names

      track_file_name = file_names.track release[0]

      assert_path release.path.join(track_file_name)
    end

    def test_image_file_are_renamed_according_to_given_name
      release = configure do |release|
        release.image 'cover.jpg'
      end

      cover_path = release.path.join('cover.jpg')

      image = FakeImage.new cover_path, 'artwork.jpg'

      package release, images: [ image ]

      refute_path cover_path
      assert_path release.path.join(image.name)
    end

    def test_playlists_are_written_according_to_file_with_content
      playlist = FakeFile.new 'playlist.m3u', 'fake playlist'

      release = configure

      package release, playlists: [ playlist ]

      written_content = read release.path.join(playlist.name)
      assert_equal playlist.content, written_content
    end

    def test_cue_sheets_are_written_according_to_file_with_content
      cue_sheet = FakeFile.new 'cue_sheet.cue', 'fake cue_sheet'

      release = configure

      package release, cue_sheets: [ cue_sheet ]

      written_content = read release.path.join(cue_sheet.name)
      assert_equal cue_sheet.content, written_content
    end

    def test_logs_are_written_according_to_file_with_content
      log = FakeFile.new 'rip.log', 'fake log'

      release = configure

      package release, logs: [ log ]

      written_content = read release.path.join(log.name)
      assert_equal log.content, written_content
    end

    def test_creates_an_sfv_file_using_the_generated_file_name
      file_names = FakeFileNameGenerator.new

      release = configure

      package release, file_names: file_names

      assert_path release.path.join(file_names.sfv)
    end

    def test_release_directory_is_renamed_according_to_generated_name
      file_names = FakeFileNameGenerator.new

      release = configure

      directory = release.dirname

      package release, file_names: file_names

      assert_equal directory.join(file_names.release), release.path
    end

    def assert_path(path)
      assert path.exist?, "#{path} should exist"
    end

    def refute_path(path)
      refute path.exist?, "#{path} should not exist"
    end
  end
end
