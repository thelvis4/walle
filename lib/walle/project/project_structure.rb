module Walle
  class ProjectStructure

    attr_reader :path, :domain, :project_name

    def initialize(path, domain, project_name)
      Args.validate(path, :path)
      Args.validate(domain, :domain)
      Args.validate(project_name, :project_name)

      @path = path
      @domain = domain
      @project_name = project_name
    end

    def generate
      generate_folder_structure
    end

    def src_path
      File.join(path, DirectoryName.src)
    end

    def bin_path
      File.join(path, DirectoryName.bin)
    end

    def values_path
      File.join(res_path, DirectoryName.values)
    end

    def res_path
      File.join(path, DirectoryName.res)
    end
    
    def obj_path
      File.join(path, DirectoryName.obj)
    end

    def lib_path
      File.join(path, DirectoryName.lib)
    end

    def drawable_path
      File.join(res_path, DirectoryName.drawable)
    end

    def package_path
      File.join(path, package_folder_components)
    end

    def manifest_path
      File.join(path, FileName.manifest)
    end
      
    def package_folder_components
      domain_components = domain.no_spaces.gsub(".", "/")
      File.join(DirectoryName.src, domain_components, project_name.no_spaces.downcase)
    end

    def unsigned_APK_path
      File.join(bin_path, "#{project_name}.unsigned.apk")
    end

    def signed_APK_path
      File.join(bin_path, "#{project_name}.signed.apk")
    end

    def APK_path
      File.join(bin_path, "#{project_name}.apk")
    end

    def temp_keystore_path
      File.join(path, "#{project_name}.keystore")
    end

    private

    def generate_folder_structure   
      UI.start_step "Creating folders structure"

      directories.each { |dir|
        dir_path = File.join(path, dir)
        UI.verbose "Create #{dir_path.gsub(path, '')}"
        FileUtils.mkdir_p dir_path
      }
    end
      
    def directories
      [
        package_folder_components,
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
