module Walle
  class ProjectGenerator
    
    attr_reader :location, :project_name, :company_domain
    attr_accessor :structure, :placeholders, :path

    def initialize(args)
      validate_args args
    end

    def generate      
      create_location_dir
      generate_project_folder
      generate_project_structure
      copy_files

      UI.finish_action "Project was successfully created at #{path}"
    end

    def path
      @path ||= File.join(location, project_name)
    end
    
    def structure
      @structure ||= ProjectStructure.new(path, company_domain, project_name)
    end

    private
    
    def create_location_dir
      unless Dir.exist?(location)
        UI.verbose "Creating project location directory #{location}"
        FileUtils.mkdir_p(location)
      end
    end

    def generate_project_folder
      UI.start_step "Create project folder #{path}"
      FileUtils.mkdir_p path
    end

    def generate_project_structure
      structure.generate()
    end
    
    def copy_files
      UI.start_step "Copying project files"
      copy_icon
      copy_templates
    end

    def copy_icon
      destination = File.join(structure.drawable_path, FileName.icon)
      FileUtils.cp(FilePath.icon, destination)
      UI.verbose "Copied #{FileName.icon}"
    end

    def copy_templates
      templates_location_map.each { |locations|
        placeholders.copy(locations[:from], locations[:to])
      }
    end

    def templates_location_map
      [
        {
          :from => FilePath.build_configuration_template,
          :to => File.join(path, FileName.build_configuration)
        },
        {
          :from => FilePath.manifest_template,
          :to => File.join(path, FileName.manifest) 
        },
        {
          :from => FilePath.strings_template,
          :to => File.join(structure.values_path, FileName.strings)
        },
        {
          :from => FilePath.source_template,
          :to => File.join(structure.package_path, "#{project_name.no_spaces}.java")
        }
      ]
    end

    def placeholders
      @placeholders ||= initialize_placeholders
    end

    def initialize_placeholders
      Placeholders.new(
        :company_domain => company_domain,
        :project_name => project_name
        )
    end

    def validate_args(args)
      name = args[:project_name]
      if name.nil? || name.empty?
        raise ArgumentError.new "Project should be initialized with 'project_name' parameter"
      end
      @project_name = name 
      @location = args[:location] || Dir.pwd
      @company_domain = args[:company_domain] || "com.company"
    end

  end
end

require 'fileutils'
