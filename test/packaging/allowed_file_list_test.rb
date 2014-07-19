require_relative '../test_helper'

module Decks
  class AllowedFileListTest < MiniTest::Unit::TestCase
    def test_includes_the_tracks_and_the_cover
      release = configure do |release|
        release.track 'example.mp3'
        release.image 'cover.jpg'
      end

      list = AllowedFileList.new release

      assert_includes list, release.path.join('example.mp3')
      assert_includes list, release.path.join('cover.jpg')
    end
  end
end
