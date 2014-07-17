module Decks
  class SetCatalogueNumberScreen < TextInputScreen
    include Concord.new(:configuration, :next_state)

    def set(text)
      configuration.catalogue_number = text
    end

    def prompt
      'Enter catalogue #'
    end
  end
end
