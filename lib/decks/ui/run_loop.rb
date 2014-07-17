module Decks
  class RunLoop
    include Concord.new(:stdin, :router)

    def start(initial_state)
      router.goto initial_state

      catch :done do
        loop do
          router.input stdin.gets.strip
        end
      end
    end
  end
end
