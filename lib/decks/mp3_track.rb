module Decks

  # http://help.mp3tag.de/main_tags.html
  class Mp3Track
    attr_reader :path

    def initialize(path)
      @path = Pathname.new path.to_s

      fail "#{path} doesn't exist!" unless @path.exist?

      yield self if block_given?
    end

    def to_s
      path.to_s
    end

    def rename(base_name)
      directory = File.dirname path
      new_path = File.join directory, "#{base_name}.mp3"
      FileUtils.mv path, new_path

      @path = Pathname.new new_path
    end

    def artist
      fetch :TPE1
    end

    def artist=(name)
      execute '--artist', name
    end

    def album
      fetch :TALB
    end

    def album=(name)
      execute '--album', name
    end

    def title
      fetch :TIT2
    end

    def title=(value)
      execute '--song', value
    end

    def track=(number)
      if total_tracks
        execute '--track', "#{number}/#{total_tracks}"
      else
        execute '--track', number
      end
    end

    def track
      tag = fetch :TRCK
      return unless tag

      value = tag.split('/').first.to_i
      value == 0 ? nil : value
    end

    def total_tracks
      tag = fetch :TRCK
      return unless tag

      parts = tag.split('/')

      if parts.size == 1
        nil
      else
        value = parts.last.to_i
        value == 0 ? nil : value
      end
    end

    def total_tracks=(count)
      raise TagNotWritableError, "Cannot write total tracks for #{path} w/o a track" unless track
      execute '--track', "#{track}/#{count}"
    end

    def disc
      tag = fetch :TPOS
      return unless tag

      value = tag.split('/').first.to_i
      value == 0 ? nil : value
    end

    def disc=(number)
      if total_discs
        execute '--TPOS', "#{number}/#{total_discs}"
      else
        execute '--TPOS', number
      end
    end

    def total_discs
      tag = fetch :TPOS
      return unless tag

      parts = tag.split('/')

      if parts.size == 1
        nil
      else
        value = parts.last.to_i
        value == 0 ? nil : value
      end
    end

    def total_discs=(count)
      raise TagNotWritableError, "Cannot write total discs for #{path} w/o a disc" unless disc
      execute '--TPOS',  "#{disc}/#{count}"
    end

    def album_artist
      fetch :TPE2
    end

    def album_artist=(name)
      execute '--TPE2', name
    end

    def year
      value = fetch :TYER
      value ? value.to_i : nil
    end

    def year=(date)
      execute '--year', date
    end

    def compilation=(flag)
      frames[:compilation] = flag
      return unless flag

      execute '--TXXX', 'Compilation: 1'
    end

    def compilation?
      frames[:compilation]
    end

    def label
      fetch :TPUB
    end

    def label=(value)
      v = value.to_s.strip
      return if v.empty?

      execute '--TPUB', v
    end

    private
    def frames
      output = encode_properly(`id3v2 -l "#{path}"`).split("\n")

      tags = output.select do |line|
        line =~ /T[A-Z0-9]{3}/
      end

      tags.each_with_object({ }) do |line, hash|
        if line =~ /TXXX.+\(Compilation\).+1/
          hash[:compilation] = true
        elsif line !~ /\ATXXX/
          match = line.match /\A(T[A-Z0-9]{3})\s\(.*\):\s(.+)\z/
          next unless match

          hash[match[1].to_sym] = match[2]
        end
      end
    end

    def encode_properly(text)
      if text.force_encoding('UTF-8').valid_encoding?
        text
      elsif text.force_encoding('ISO-8859-1').valid_encoding?
        text.encode 'UTF-8'
      else
        fail "#{path} is spewing bad encodings"
      end
    end

    def fetch(name)
      value = frames[name]
      value &&= value.strip

      return unless value
      return if value.strip.empty?

      if block_given?
        yield value
      else
        value
      end
    end

    def execute(tag, value)
      system %Q{id3v2 #{tag} "#{value}" "#{path}"}
    end
  end
end
