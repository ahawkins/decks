module Decks
  class AudioFile < SimpleDelegator
    def initialize(path)
      case path.to_s
      when /\.mp3$/
        super Mp3Track.new(path)
      when /\.flac$/
        super FlacTagger.new(path)
      else
        fail "No parser for #{path}"
      end

      yield self if block_given?
    end
  end
end
