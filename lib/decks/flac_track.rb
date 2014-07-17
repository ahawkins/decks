module Decks
  class FlacTrack
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def title
      fetch 'TITLE'
    end

    def track
      fetch 'TRACKNUMBER' do |tag|
        value = tag.split('/').first.to_i
        value == 0 ? nil : value
      end
    end

    def track=(number)
      write 'TRACKNUMBER', number
    end

    def total_tracks
      fetch 'TRACKTOTAL' do |tag|
        tag.to_i == 0 ? nil : tag.to_i
      end
    end

    def total_tracks=(count)
      write 'TRACKTOTAL', count.to_i
    end

    def artist
      fetch 'ARTIST'
    end

    def album_artist
      fetch 'ALBUMARTIST'
    end

    def album_artist=(name)
      write 'ALBUMARTIST', name
    end

    def album
      fetch 'ALBUM'
    end

    def year
      fetch 'DATE'
    end

    def year=(date)
      write 'DATE', date.to_i
    end

    def disc
      fetch 'DISCNUMBER' do |tag|
        tag.to_i == 0 ? nil : tag.to_i
      end
    end

    def disc=(number)
      write 'DISCNUMBER', number.to_i
    end

    def total_discs
      fetch 'DISCTOTAL' do |tag|
        tag.to_i == 0 ? nil : tag.to_i
      end
    end

    def total_discs=(count)
      write 'DISCTOTAL', count.to_i
    end

    def to_s
      path
    end

    def to_path
      Pathname.new path
    end

    def cd?
      path =~ /-(\d?)CD-/
    end

    def compilation=(flag)
      write "COMPILATION", (flag ? 1 : 0)
    end

    def compilation?
      fetch("COMPILATION").to_i == 1
    end

    def release
      File.basename File.dirname(path)
    end

    private
    def tags
      @tags ||= read_tags
    end

    def read_tags
      `metaflac --export-tags-to=- #{Shellwords.escape(path)}`.split("\n").inject({}) do |hash, line|
        parts = line.split('=')
        if parts[0]
          hash.merge parts[0].upcase => parts[1]
        else
          hash
        end
      end
    end

    def write(name, value)
      @tags[name] = value

      clear_command = %Q{metaflac --remove-tag "#{name}" #{Shellwords.escape(path)}}
      set_command = %Q{metaflac --set-tag="#{name}=#{value}" #{Shellwords.escape(path)}}

      system "#{clear_command} && #{set_command}"
    end

    def fetch(name)
      value = tags[name]
      value &&= value.strip

      return unless value
      return if value.strip.empty?

      if block_given?
        yield value
      else
        value
      end
    end
  end
end
