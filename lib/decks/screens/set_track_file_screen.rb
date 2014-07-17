module Decks
  class SetTrackFileScreen < SelectFileScreen
    def set(file)
      model.path = file
    end

    def files
      '*.{mp3,flac}'
    end
  end
end
