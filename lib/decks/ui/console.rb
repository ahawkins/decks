module Decks
  class Console
    include Concord.new(:io)

    def puts(string)
      io.puts string
    end

    def flush
      io.print "\e[2J\e[f"
    end

    def print(string)
      io.print string
    end

    def prompt(message)
      io.print "#{message} > "
    end

    def printf(format, *args)
      puts(format % args)
    end

    def separator
      puts "\n"
    end

    def header(message)
      printf "==== %s ====", message
    end

    def warn(message)
      printf '  *** %s *** ', message
    end
  end
end
