require_relative '../test_helper'

module Decks
  class ImageManifestTest < MiniTest::Unit::TestCase
    class FakeFileNameGenerator
      def cover
        'test-cover.jpg'
      end
    end

    attr_reader :file_names

    def setup
      @file_names = FakeFileNameGenerator.new
      super
    end

    def test_includes_the_cover_image_according_to_generated_name
      release = configure do |release|
        release.image 'cover.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 1, images.count

      cover = images.cover

      assert_includes images, cover, 'Cover should be in the release'

      assert_equal release.path.join('cover.jpg'), cover.path
      assert_equal file_names.cover, cover.name
    end

    def test_includes_the_proof
      skip
    end

    def test_is_empty_if_there_is_no_cover
      release = configure

      images = ImageManifest.new release, file_names

      refute images.any?
    end
  end
end
