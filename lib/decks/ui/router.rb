module Decks
  class Router
    class UnknownCommandError < StandardError
      def initialize(state, input)
        super "#{state.class.name} does not handle '#{input}'"
      end
    end

    def initialize(io)
      @view = Console.new io
    end

    def goto(next_state)
      state.exited if state

      @state = next_state
      state.router = self

      state.entered

      state.draw view
    end

    def input(text)
      state.input text
    end

    def loop
      goto state
    end

    def state
      @state
    end

    private
    def view
      @view
    end
  end
end
