module Decks
  class CdReleaseValidator < DelegateClass(Release)
    attr_reader :errors

    def initialize(release)
      super release
      @errors = [ ]
    end

    def valid?
      errors.clear

      validate_basics
      validate_naming

      errors.empty?
    end

    private
    def validate_basics
      errors << 'Name missing' unless name
      errors << 'Artists missing' if artists.empty?
      errors << 'Year missing' unless year
      errors << 'Tracks missing' if tracks.empty?

      tracks.each do |track|
        errors << 'Track # missing' unless track.number
        errors << 'Disc # missing' unless track.disc
        errors << 'Track title missing' unless track.title
        errors << 'Track artist missing' unless track.artist
      end

      errors << 'Total discs different than format' unless discs == cds

      unique_track_numbers = tracks.uniq do |track|
        "#{track.disc}.#{track.number}"
      end

      errors << 'Track/disc numbers duplicated' unless unique_track_numbers.size == tracks.size

      errors << 'Must have a log for each disc' unless logs.size == discs
      errors << 'Must have a cue for each mix' if mixed_tracks? && (cues.size != mixed_tracks.size)

      errors << 'All cues must have content' unless cues.all?(&:text)
      errors << 'All logs must have content' unless logs.all?(&:text)
    end

    def validate_naming
      if name =~ mixed_regex && !compilation?
        errors << 'Indicated mix release, but did not compilation'
      end

      return unless compilation?

      non_va = tracks.any? do |track|
        track.mixed? && track.artist != 'VA'
      end

      errors << 'Mixed on this compilation are not VA' if non_va

      artists.each do |artist|
        errors << "Name does not include #{artist}" unless name.include? artist
      end

      if name.to_s =~ mixed_regex && mixed_tracks.size == 0
        errors << 'Looks like mix, but no mixed tracks'
      end

      if single_disc? && compilation?
        mix_track = tracks.find(&:mixed?)
        return unless mix_track

        errors << 'single mix cd title must be release title' unless mix_track.title == name
      end

      if multiple_artists? & multi_disc?
        artist_included = tracks.select do |track|
          artists.any? do |artist|
            track.title.include? artist
          end
        end

        on_each_track = artist_included.size == tracks.size

        errors << 'Multi CD should indicate mixer on each CD' unless on_each_track

        mentioned_artists = artists.count do |artist|
          tracks.any? do |track|
            track.title.include? artist
          end
        end

        each_artist_mentioned = mentioned_artists == tracks.size

        errors << 'Multi artists mixes should mention each artist' unless each_artist_mentioned
      end
    end

    def discs
      tracks.map(&:disc).uniq.size
    end

    def mixed_regex
      /\(Mixed\sby\s(.+)\)/
    end

    def multiple_artists?
      artists.size > 1
    end

    def multi_disc?
      discs > 1
    end

    def mixed_tracks
      tracks.select(&:mixed?)
    end

    def mixed_tracks?
      mixed_tracks.any?
    end

    def single_disc?
      discs == 1
    end

    def cds
      match = format.match /(\d+)CD/
      match ? match[1].to_i : 1
    end
  end
end
