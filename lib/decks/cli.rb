require 'thor'

module Decks
  class CLI < Thor
    desc 'release PATH', 'Prepare release using PATH'
    option :format, required: true, type: :string, aliases: '-f'
    option :artist, type: :string, aliases: '-a'
    option :name, type: :string, aliases: '-n'
    option :year, type: :numeric, aliases: '-y'
    option :compilation, type: :boolean, aliases: '-c'
    def release(path)
      configuration = Release.from_path path do |config|
        config.format = options[:format]
        config.artists = Array(options[:artist])
        config.name = options[:name]
        config.year = options[:year].to_i
        config.compilation = options[:compilation]
      end

      UI.start configuration, $stdout, $stdin
    end
  end
end
