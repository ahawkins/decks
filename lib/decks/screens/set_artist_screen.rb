module Decks
  class SetArtistScreen < TextInputScreen
    include Concord.new(:release, :next_state)

    def set(text)
      release.artists = text.split(',').map(&:strip)
    end

    def prompt
      'Enter release artist'
    end
  end
end
