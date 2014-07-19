module Decks
  class WebFileNameGenerator < DelegateClass(FileNameGenerator)
    def nfo
      prepend super
    end

    def sfv
      prepend super
    end

    def cover
      prepend super
    end

    def playlist
      prepend super
    end

    def mixed_playlist
      prepend super
    end

    def unmixed_playlist
      prepend super
    end

    private
    def prepend(text)
      "00-#{text}"
    end
  end
end
