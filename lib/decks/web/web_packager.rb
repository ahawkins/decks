module Decks
  class WebPackager
    class << self
      def build(configuration)
        file_names = WebFileNameGenerator.new FileNameGenerator.new(configuration)

        Packager.new({
          configuration: configuration,
          validator: WebValidator.new(configuration),
          file_names: file_names,
          tagger: WebMetaTagger.new(configuration),
          images: ImageManifest.new(configuration, file_names),
          playlists: PlaylistManifest.new(configuration.tracks, file_names),
          cue_sheets: WebCueSheetManifest.new(configuration, file_names),
          logs: [ ]
        })
      end
    end
  end
end
