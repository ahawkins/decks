module Decks
  class NumberInputScreen
    include Screen

    def draw(view)
      view.prompt prompt
    end

    def prompt
      fail "#{self.class}#prompt is not implemented"
    end

    def input(text)
      case text
      when /\A[0-9]+\z/
        set text.to_i
        goto next_state
      else
        router.loop
      end
    end

    def set(text)
      fail "#{self.class}#set is not implemented"
    end

    def next_state
      fail "#{self.class}#next_state is not implemented"
    end
  end
end
