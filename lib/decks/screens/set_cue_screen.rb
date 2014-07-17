module Decks
  class SetCueScreen < SelectFileScreen
    def set(path)
      model.cue = File.read path
    end

    def files
      '*.cue'
    end
  end
end
