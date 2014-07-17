module Decks
  class SetNameScreen < TextInputScreen
    include Concord.new(:configuration, :next_state)

    def set(text)
      configuration.name = text
    end

    def prompt
      'Enter release name'
    end
  end
end
