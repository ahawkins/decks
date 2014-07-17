module Decks
  class AddTrackScreen < SelectMultipleFilesScreen
    def files
      '*.{mp3,flac}'
    end

    def set_each(paths)
      paths.each do |path|
        audio_file = AudioFile.new path

        track = Configuration::Track.new
        track.path = path

        track.artist = audio_file.artist
        track.title = audio_file.title
        track.number = audio_file.track
        track.disc = audio_file.disc
        track.mixed = mixed? audio_file

        track.artist = track.mixed? ? 'VA' : audio_file.artist

        model << track
      end
    end

    def mixed?(file)
      title = file.title
      return false unless title

      title =~ /(continuous.+mix|mixed.+by)/i
    end
  end
end
