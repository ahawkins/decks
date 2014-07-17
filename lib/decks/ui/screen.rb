module Decks
  module Screen
    attr_writer :router

    def goto(next_state)
      router.goto next_state
    end

    def loop
      router.loop
    end

    def draw(view)

    end

    def input(text)
      unknown_command text
    end

    def unknown_command(input)
      fail Router::UnknownCommandError.new(self, input)
    end

    def entered

    end

    def exited

    end

    private
    def router
      @router
    end
  end
end
