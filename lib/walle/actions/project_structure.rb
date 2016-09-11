module Walle
  class ProjectStructure

    attr_reader :project_path, :company_domain

    def initialize(project_path, company_domain)
      Args.validate(project_path, :project_path)
      Args.validate(company_domain, :company_domain)
      @project_path = project_path
      @company_domain = company_domain
    end

    def generate
      generate_folder_structure
    end

    def values_path
      File.join(res_path, DirectoryName.values)
    end

    def res_path
      File.join(project_path, File.join(DirectoryName.res))
    end

    def package_path
      File.join(project_path, package_folder_components)
    end

    private

    def generate_folder_structure   
      UI.message "Creating folders structure"
      UI.verbose "Create #{project_path}"
      FileUtils.mkdir_p project_path

      directories.each { |dir|
        dir_path = File.join(project_path, dir)
        UI.verbose "Create #{dir_path.gsub(project_path, '')}"
        FileUtils.mkdir_p dir_path
      }
      UI.verbose "Folder structure was created successfully"
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

    def package_folder_components
      domain_components = company_domain.gsub(".","/")
      File.join(DirectoryName.src, domain_components)
    end

  end
end
