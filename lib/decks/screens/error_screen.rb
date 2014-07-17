module Decks
  class ErrorScreen
    include Screen
    include Concord.new(:message, :next_state)

    def draw(view)
      view.puts "Seems there's a problem: #{message}"
      view.puts "Press any key to continue..."
    end

    def input(text)
      goto next_state
    end
  end
end
