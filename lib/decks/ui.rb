module Decks
  class UI
    include Concord.new(:stdout, :stdin, :initial_screen)

    class << self
      def start(release, stdout, stdin)
        case release.format
        when /cd/i, /web/i
          new(stdout, stdin, MainMenuScreen.new(release)).start
        else
          fail "Unknown release format!"
        end
      end
    end

    def start
      router = Router.new stdout
      run_loop = RunLoop.new stdin, router
      run_loop.start initial_screen
    end
  end
end
