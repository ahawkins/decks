module Decks
  class Packager
    include Anima.new(*[
      :configuration,
      :validator,
      :file_names,
      :tagger,
      :images,
      :playlists,
      :cue_sheets,
      :logs
    ])

    PackageError = Class.new StandardError

    def package!
      validate
      delete_unknown_files
      write_tags
      create_nfo
      rename_tracks
      rename_images
      create_playlists
      create_cue_sheets
      create_logs
      create_sfv
      rename_release_directory
    end

    private
    def working_directory
      configuration.path
    end

    def validate
      fail PackageError, "Cannot package because of errors: #{validator.errors}" unless validator.valid?
    end

    def known_files
      configuration.tracks.map(&:path) + images.map(&:path)
    end

    def delete_unknown_files
      configuration.path.children.each do |file|
        next if known_files.include? file
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

    def rename_tracks
      configuration.tracks.each do |track|
        new_file_name = file_names.track track
        track.rename working_directory.join(new_file_name)
      end
    end

    def rename_images
      images.each do |image|
        new_path = working_directory.join image.name
        image.path.rename new_path
      end
    end

    def create_playlists
      playlists.each do |playlist|
        File.open working_directory.join(playlist.name), 'w' do |file|
          file.write playlist.content
        end
      end
    end

    def create_cue_sheets
      cue_sheets.each do |cue_sheet|
        File.open working_directory.join(cue_sheet.name), 'w' do |file|
          file.write cue_sheet.content
        end
      end
    end

    def create_logs
      logs.each do |log|
        File.open working_directory.join(log.name), 'w' do |file|
          file.write log.content
        end
      end
    end

    def create_sfv
      FileUtils.touch working_directory.join(file_names.sfv)
    end

    def rename_release_directory
      configuration.move working_directory.dirname.join(file_names.release)
    end
  end
end
