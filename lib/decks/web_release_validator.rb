module Decks
  class WebReleaseValidator < DelegateClass(Release)
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
      errors << 'Release Name missing' unless name
      errors << 'Release Artists missing' if artists.empty?
      errors << 'Release Year missing' unless year
      errors << 'No tracks' if tracks.empty?

      tracks.each do |track|
        errors << 'Track # missing' unless track.number
        errors << 'Track title missing' unless track.title
        errors << 'Track artist missing' unless track.artist
      end

      errors << 'Track numbers duplicated' unless tracks.uniq(&:number).size == tracks.size
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
        errors << "Compilation releases does not include #{artist} in name" if name && !name.include?(artist)
      end

      if name.to_s =~ mixed_regex && continuous_mixes.size == 0
        errors << 'Looks like mixed release, but no mixed tracks'
      end

      if multiple_artists? && continuous_mixes?
        artist_included = tracks.select do |track|
          artists.any? do |artist|
            track.title.include?(artist) && track.mixed?
          end
        end

        on_each_mix = artist_included.size == continuous_mixes.size

        errors << 'Multi mix release should indicate mixer on each mix' unless on_each_mix

        mentioned_artists = artists.count do |artist|
          tracks.any? do |track|
            track.title.include?(artist) && track.mixed?
          end
        end

        each_artist_mentioned = mentioned_artists == artists.size

        errors << 'Multi artists mixes should mention each artist' unless each_artist_mentioned
      end
    end

    def mixed_regex
      /\(Mixed\sby\s(.+)\)/
    end

    def multiple_artists?
      artists.size > 1
    end

    def continuous_mixes
      tracks.select(&:mixed?)
    end

    def continuous_mixes?
      continuous_mixes.any?
    end
  end
end
