module Decks
  class RunLoop
    include Concord.new(:stdin, :router)

    def start(initial_state)
      router.goto initial_state

      catch :done do
        loop do
          begin
            router.input stdin.gets.strip
          rescue Router::UnknownCommandError
            router.loop
          end
        end
      end
    end
  end
end
