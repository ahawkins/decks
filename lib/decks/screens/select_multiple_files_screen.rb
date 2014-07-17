module Decks
  class SelectMultipleFilesScreen < SelectFileScreen
    def input(text)
      case text.downcase
      when 'a'
        set_each choices.values
        goto next_state
      else
        super
      end
    end

    def set(file)
      set_each [file]
    end

    def set_each(path)
      fail "#{self.class}#set_each not defined"
    end

    def prompt
      'Enter file # or A to select all'
    end
  end
end
