module Decks
  class BooleanInputScreen
    include Screen

    def draw(view)
      view.puts "(Y)es or (N)o"
      view.prompt prompt
    end

    def prompt
      fail "#{self.class}#prompt is not implemented"
    end

    def input(text)
      case text.downcase
      when 'y'
        set true
        goto next_state
      when 'n'
        set false
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
