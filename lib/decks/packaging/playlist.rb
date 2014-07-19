module Decks
  class Playlist
    attr_reader :name, :list

    def initialize(name, list)
      @name, @list = name, list
    end

    def ==(other)
      return false unless other.instance_of? self.class
      other.name == name && other.list == list
    end

    def [](index)
      list[index]
    end

    def size
      list.size
    end

    def content
      list.join("\n")
    end
  end
end
