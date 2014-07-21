module Decks
  class MetaTagger
    include Concord.new(:release)

    def write_tags(track)
      AudioFile.new track.path do |tags|
        tags.track = track.number
        tags.title = track.title

        tags.album = release.name
        tags.album_artist = release.artists.join(' & ')

        tags.year = release.year

        tags.compilation = release.compilation?

        tags.label = release.label
      end
    end
  end
end
