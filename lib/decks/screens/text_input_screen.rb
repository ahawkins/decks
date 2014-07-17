module Decks
  class TextInputScreen
    include Screen

    def draw(view)
      view.prompt prompt
    end

    def prompt
      fail "#{self.class}#prompt is not implemented"
    end

    def input(text)
      set text
      goto next_state
    end

    def set(text)
      fail "#{self.class}#set is not implemented"
    end

    def next_state
      fail "#{self.class}#next_state is not implemented"
    end
  end
end
