module Decks
  class SetLabelScreen < TextInputScreen
    include Concord.new(:configuration, :next_state)

    def set(text)
      configuration.label = text
    end

    def prompt
      'Enter label'
    end
  end
end
