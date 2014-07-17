module Decks
  class TrackScreen
    include Screen
    include Concord.new(:configuration, :track, :next_step)

    class Presenter < DelegateClass(Configuration::Track)
      def file
        name ? name : 'N/A'
      end

      def title
        super ? super : 'N/A'
      end

      def artist
        super ? super : 'N/A'
      end

      def number
        super ? super : 'N/A'
      end

      def mixed?
        super ? 'Yes' : 'No'
      end

      def cue
        super ? "#{super[0..15]}.." : 'N/A'
      end
    end

    def draw(view)
      view.flush

      view.header 'Update Track'

      presenter = Presenter.new track

      view.printf '(%s) %s: %s', 'F', 'File', presenter.file
      view.printf '(%s) %s: %s', 'T', 'Title', presenter.title
      view.printf '(%s) %s: %s', 'A', 'Artist', presenter.artist
      view.printf '(%s) %s: %s', '#', 'Number', presenter.number
      view.printf '(%s) %s: %s', 'M', 'Mixed', presenter.mixed?
      view.printf '(%s) %s: %s', 'C', 'Cue #', presenter.cue

      view.separator

      view.prompt 'Enter choice or (B)ack'
    end

    def input(letter)
      case letter.downcase
      when 't'
        goto SetTrackTitleScreen.new(track, self)
      when 'a'
        goto SetTrackArtistScreen.new(track, self)
      when 'n', '#'
        goto SetTrackNumberScreen.new(track, self)
      when 'm'
        goto SetTrackMixScreen.new(track, self)
      when 'f'
        goto SetTrackFileScreen.new(track, path, self)
      when 'c'
        goto SetCueScreen.new(track, path, self)
      when 'b'
        goto next_step
      else
        unknown_command letter
      end
    end

    private
    def path
      configuration.path
    end
  end
end
