module Walle
  class ProjectStructure

    attr_reader :path, :package_components

    def initialize(path, package_components)
      Args.validate(path, :path)
      Args.validate(package_components, :package_components)
      @path = path
      @package_components = package_components
    end

    def generate
      generate_folder_structure
    end

    def values_path
      File.join(res_path, DirectoryName.values)
    end

    def res_path
      File.join(path, File.join(DirectoryName.res))
    end

    def drawable_path
      File.join(res_path, DirectoryName.drawable)
    end

    def package_path
      File.join(path, package_components)
    end

    private

    def generate_folder_structure   
      UI.message "Creating folders structure"

      directories.each { |dir|
        dir_path = File.join(path, dir)
        UI.verbose "Create #{dir_path.gsub(path, '')}"
        FileUtils.mkdir_p dir_path
      }
      UI.verbose "Folder structure was created successfully"
    end
      
    def directories
      [
        package_components,
        File.join(DirectoryName.res, DirectoryName.drawable),
        File.join(DirectoryName.res, DirectoryName.layout),
        File.join(DirectoryName.res, DirectoryName.values),
        DirectoryName.obj,
        DirectoryName.lib,
        DirectoryName.bin,
        DirectoryName.docs
      ]
    end

  end
end
