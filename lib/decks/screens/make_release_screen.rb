module Decks
  class MakeReleaseScreen
    include Screen
    include Concord.new(:release, :next_step)

    def entered
      if release.ok?
        release.release!
      else
        goto ErrorScreen.new('Release has problems, fix them first', next_step)
      end
    end

    def draw(view)
      view.header 'Release Created!'

      view.separator

      view.printf '%s: %s', 'Name', release.basename

      view.separator

      release.files.each do |path|
        view.printf ' - %s', path.basename
      end

      view.puts '(Q)uit or any key to continue...'
    end

    def input(string)
      case string.downcase
      when 'q'
        throw :done
      else
        goto next_step
      end
    end
  end
end
