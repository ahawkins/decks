require 'thor'

module Decks
  class CLI < Thor
    desc 'release PATH', 'Prepare release using PATH'
    option :format, required: true, type: :string
    def release(path)
      configuration = Release.from_path path do |config|
        config.format = options[:format]
      end

      UI.start configuration, $stdout, $stdin
    end
  end
end
