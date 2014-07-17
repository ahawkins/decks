module Decks
  class SetCompilationScreen < BooleanInputScreen
    include Concord.new(:configuration, :next_state)

    def set(flag)
      configuration.compilation = flag
    end

    def prompt
      'Is this release a compilation?'
    end
  end
end
