module Decks
  class MainMenuScreen
    include Screen

    include Concord.new(:pipeline)

    def draw(view)
      view.flush

      view.header "DECKS Release Builder"

      view.separator

      view.printf '%s: %s', 'Directory', pipeline.basename
      view.printf '%s: %s', 'Format', pipeline.format

      if problems?
        view.separator
        view.warn 'Cannot release yet!'
      end

      view.separator

      view.puts '(%s) %s: %s' % [ 'A', 'Artist', artist ]
      view.puts '(%s) %s: %s' % [ 'N', 'Name', pipeline.name ]
      view.puts '(%s) %s: %s' % [ 'C', 'Compilation', compilation ]
      view.puts '(%s) %s: %s' % [ 'Y', 'Year', pipeline.year ]
      view.puts '(%s) %s: %s' % [ 'L', 'Label', pipeline.label ]
      view.puts '(%s) %s: %s' % [ '#', 'Catalogue #', pipeline.catalogue_number ]

      view.puts '(%s) %s' % [ 'T', 'Tracks' ]

      view.separator

      if problems?
        view.header 'Problems'
        view.separator

        problems.each do |message|
          view.printf '- %s', message
        end

        view.separator
      end

      view.prompt 'Enter choice'
    end

    def artist
      pipeline.artists.join ', '
    end

    def compilation
      pipeline.compilation? ? 'Yes' : 'No'
    end

    def input(letter)
      case letter.downcase
      when 'a'
        goto SetArtistScreen.new(pipeline, self)
      when 'n'
        goto SetNameScreen.new(pipeline, self)
      when 'y'
        goto SetYearScreen.new(pipeline, self)
      when 'c'
        goto SetCompilationScreen.new(pipeline, self)
      when 'l'
        goto SetLabelScreen.new(pipeline, self)
      when '#'
        goto SetCatalogueNumberScreen.new(pipeline, self)
      when 't'
        goto TrackListScreen.new(pipeline, pipeline.tracks, self)
      when 'r'
        goto MakeReleaseScreen.new(pipeline, self)
      else
        unknown_command letter
      end
    end

    private
    def problems?
      pipeline.problems?
    end

    def problems
      pipeline.problems
    end
  end
end
