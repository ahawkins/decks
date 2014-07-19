module Decks
  class Packager
    include Anima.new(*[
      :configuration,
      :validator,
      :file_names,
      :allowed_files,
      :tagger,
      :playlists,
      :cue_sheets,
      :logs
    ])

    PackageError = Class.new StandardError

    def package!
      # validate
      delete_unknown_files
      # write_tags
      # create_nfo
      # rename_tracks
      #
      # rename_cover
      #
      # playlists.each do |playlist|
      #   File.open working_directory.join(playlist.name), 'w' do |file|
      #     file.puts playlist.content
      #   end
      # end
      #
      # create_sfv
      # rename_release_directory
    end

    private
    def validate
      return unless alidator.valid?

      fail PackageError, "Cannot package because of errors: #{validator.errors}"
    end

    def delete_unknown_files
      configuration.path.children.each do |file|
        next if allowed_files.include? file

        FileUtils.rm_rf file
      end
    end

    def write_tags
      configuration.tracks.each do |track|
        tagger.write_tags track
      end
    end

    def create_nfo
      FileUtils.touch working_directory.join(file_names.nfo)
    end

    def create_sfv
      FileUtils.touch workign_directory.join(file_names.sfv)
    end

    def rename_tracks
      config.tracks.each do |track|
        new_file_name = names.track_file_name track
        track.rename new_file_name
      end
    end

    def rename_cover
      return unless configuration.cover?

      new_path = working_directory.join file_names.cover

      configuration.cover.rename new_path
    end

    def working_directory
      relase.directory
    end
  end
end
