module Decks
  module SanitizationHelpers
    def sanitize(value)
      copy = value.to_s.dup.strip
      copy.gsub! /m\.i\.k\.e\./i, 'MIKE'

      copy.gsub! /['"]+/, '_'
      copy.gsub! '&', 'and'
      copy.gsub! /\s+(vs\.)\s+/i, ' vs '
      copy.gsub! /[^A-Za-z0-9._\-()]+/, '_'
      copy.gsub! /_+/, '_'
      copy.gsub! /\A(_)+(.+)\z/, '\\2'
      copy.gsub! /(.+)(_)+\z/, '\\1'
      copy.gsub! /\A[^A-Za-z0-9(]/, ''
      copy.gsub! /[^A-Za-z0-9)]\z/, ''
      copy
    end
  end
end
