require 'terminal-table'

module Decks
  class TrackListScreen
    class Presenter < DelegateClass(Configuration::Track)
      def filename
        path ? truncate(name) : nil
      end

      def artist
        super ? truncate(super) : :nil
      end

      def title
        super ? truncate(super) : nil
      end

      def mix
        mixed? ? '****' : nil
      end

      private
      def truncate(string, length = 16)
        if string.length > 16
          "#{string[0, length]}..."
        else
          string
        end
      end
    end

    include Screen
    include Concord.new(:pipeline, :tracks, :next_step)

    def draw(view)
      view.flush

      view.header 'Track List'

      if problems?
        view.separator
        view.warn 'Cannot release yet!'
      end

      view.separator

      if any?
        table = Terminal::Table.new headings: [ '#', '', 'Artist', 'Title', 'File', 'Mix?' ]

        ordered.each_with_index do |track, index|
          presenter = Presenter.new track

          table << [
            '(%2d)' % [ index + 1],
            presenter.number,
            presenter.artist,
            presenter.title,
            presenter.filename,
            presenter.mix
          ]
        end

        view.puts table

        view.separator


        if problems?
          view.header 'Problems'
          view.separator

          problems.each do |message|
            view.printf '- %s', message
          end

          view.separator
        end
      else
        view.warn 'No Tracks Added'
      end

      view.separator

      view.prompt 'A(dd), B(ack), or # to edit'
    end

    def input(text)
      case text.downcase
      when /\A[0-9]+/
        input_track text.to_i
      when 'a'
        goto AddTrackScreen.new(tracks, pipeline.path, self)
      when 'b'
        goto next_step
      else
        unknown_command text
      end
    end

    private
    def input_track(number)
      track = ordered[number - 1]

      unknown_command number unless track

      goto TrackScreen.new(pipeline, track, self)
    end

    def ordered
      numbered, unumbered = tracks.partition(&:number)

      sorted = numbered.sort do |t1, t2|
        t1.number <=> t2.number
      end

      sorted + unumbered
    end

    def any?
      tracks.any?
    end

    def problems?
      pipeline.problems?
    end

    def problems
      pipeline.problems
    end
  end
end
