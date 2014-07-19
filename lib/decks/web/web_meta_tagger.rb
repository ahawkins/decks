module Decks
  class WebMetaTagger < MetaTagger
    def write_tags(track)
      tags = super
      tags.total_tracks = release.tracks.size
      tags
    end
  end
end
