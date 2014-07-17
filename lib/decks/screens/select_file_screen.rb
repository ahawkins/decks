module Decks
  class SelectFileScreen
    include Screen
    include Concord.new(:model, :directory, :next_state)

    attr_reader :choices

    def entered
      @choices = { }

      Dir[File.join(directory, files)].each_with_index do |file, i|
        choices[i+1] = file
      end

      goto ErrorScreen.new('No files to select', next_state) if choices.empty?
    end

    def draw(view)
      choices.each do |number, file|
        view.puts '(%2d) %s' % [ number, File.basename(file) ]
      end

      view.prompt prompt
    end

    def prompt
      'Select a file'
    end

    def input(text)
      case text
      when 'r'
        self.loop
      when /\A[0-9]+\z/
        handle_number_input text.to_i
      else
        unknown_command text
      end
    end

    def files
      fail "#{self.class}#files not defined"
    end

    def set(path)
      fail "#{self.class}#set not defined"
    end

    def handle_number_input(choice)
      file = choices.fetch choice do
        unknown_command choice
      end

      set file

      goto next_state
    end
  end
end
