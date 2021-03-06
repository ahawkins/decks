require_relative '../test_helper'

module Decks
  class ImageManifestTest < MiniTest::Unit::TestCase
    class FakeFileNameGenerator
      def cover
        'test-cover.jpg'
      end

      def proof
        'test-proof.jpg'
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
      release = configure do |release|
        release.image 'proof.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 1, images.count

      proof = images.proof

      assert_includes images, proof, 'proof should be in the release'

      assert_equal release.path.join('proof.jpg'), proof.path
      assert_equal file_names.proof, proof.name
    end

    def test_is_empty_if_there_is_no_cover
      release = configure

      images = ImageManifest.new release, file_names

      refute images.any?
    end

    def test_can_find_the_proof_from_multiple_images
      release = configure do |release|
        release.image 'proof.jpg'
        release.image 'cover.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 2, images.count

      assert images.proof
    end

    def test_does_not_find_the_cover_given_multiple_unknown_images
      release = configure do |release|
        release.image 'proof.jpg'
        release.image 'junk1.jpg'
        release.image 'junk2.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 1, images.count

      assert images.proof
      refute images.cover, 'Cannot find cover from junk'
    end

    def test_can_find_the_cover_given_multiple_images_if_an_image_is_named_cover
      release = configure do |release|
        release.image 'junk1.jpg'
        release.image 'junk2.jpg'
        release.image 'cover.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 1, images.count

      cover = images.cover

      assert_includes images, cover, 'Cover should be in the release'

      assert_equal release.path.join('cover.jpg'), cover.path
      assert_equal file_names.cover, cover.name
    end

    def test_can_find_the_cover_given_multiple_images_if_an_image_is_named_artwork
      release = configure do |release|
        release.image 'junk1.jpg'
        release.image 'junk2.jpg'
        release.image 'artwork.jpg'
      end

      images = ImageManifest.new release, file_names

      assert_equal 1, images.count

      cover = images.cover

      assert_includes images, cover, 'Cover should be in the release'

      assert_equal release.path.join('artwork.jpg'), cover.path
      assert_equal file_names.cover, cover.name
    end
  end
end
