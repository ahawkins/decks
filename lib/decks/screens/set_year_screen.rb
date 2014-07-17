module Decks
  class SetYearScreen < NumberInputScreen
    include Concord.new(:configuration, :next_state)

    def set(number)
      configuration.year = number
    end

    def prompt
      'Enter release year'
    end
  end
end
