require "decks/version"

require 'set'
require 'pathname'
require 'fileutils'
require 'delegate'
require 'concord'

module Decks
  # Your code goes here...
end

require 'set'
require 'delegate'

require_relative 'decks/sanitization_helpers'
require_relative 'decks/audio_file'
require_relative 'decks/mp3_track'
require_relative 'decks/flac_track'
require_relative 'decks/configuration'

require_relative 'decks/release'

require_relative 'decks/web_release_maker'

require_relative 'decks/web_release_validator'

require_relative 'decks/release_file_name_factory'
require_relative 'decks/track_file_name_factory'

require_relative 'decks/packaging/meta_tagger'

require_relative 'decks/ui'

require_relative 'decks/ui/console'
require_relative 'decks/ui/router'
require_relative 'decks/ui/screen'
require_relative 'decks/ui/run_loop'

require_relative 'decks/screens/error_screen'
require_relative 'decks/screens/select_file_screen'
require_relative 'decks/screens/select_multiple_files_screen'
require_relative 'decks/screens/text_input_screen'
require_relative 'decks/screens/boolean_input_screen'
require_relative 'decks/screens/number_input_screen'

require_relative 'decks/screens/set_artist_screen'
require_relative 'decks/screens/set_catalogue_number_screen'
require_relative 'decks/screens/set_compilation_screen'
require_relative 'decks/screens/set_cue_screen'
require_relative 'decks/screens/set_label_screen'
require_relative 'decks/screens/set_name_screen'
require_relative 'decks/screens/set_track_artist_screen'
require_relative 'decks/screens/set_track_title_screen'
require_relative 'decks/screens/set_track_mix_screen'
require_relative 'decks/screens/set_track_number_screen'
require_relative 'decks/screens/set_track_file_screen'
require_relative 'decks/screens/set_year_screen'

require_relative 'decks/screens/track_list_screen'
require_relative 'decks/screens/track_screen'
require_relative 'decks/screens/add_track_screen'

require_relative 'decks/screens/make_release_screen'

require_relative 'decks/screens/main_menu_screen'

require_relative 'decks/cli'
