module Decks
  class WebCueSheetManifest
    include Concord.new(:configuration, :file_names)

    def each(&block)
      with_cue = tracks.select(&:cue?)

      list = with_cue.map do |track|
        CueSheet.new file_names.cue(track), track.cue
      end

      list.each(&block)
    end

    private
    def tracks
      configuration.tracks
    end
  end
end
