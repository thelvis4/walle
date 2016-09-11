module Walle
  class Project
    
    attr_reader :location, :project_name, :company_domain
    attr_accessor :structure, :placeholders, :path

    def initialize(args)
      validate_args args
    end

    def self.load(path)
      
    end

    def generate
      create_location_dir
      generate_project_folder
      generate_project_structure
      copy_templates

      UI.verbose "Project was successfully create at #{path}"
    end

    def path
      @path ||= File.join(location, project_name)
    end
    
    private
    
    def create_location_dir
      unless Dir.exist?(location)
        UI.verbose "Creating project location directory #{location}"
        FileUtils.mkdir_p(location)
      end
    end

    def generate_project_folder
      UI.verbose "Create project folder #{path}"
      FileUtils.mkdir_p path
    end

    def generate_project_structure
      self.structure = ProjectStructure.new(path, company_domain)
      structure.generate()
    end

    def copy_templates
      UI.verbose "Copy template files"
      templates_location_map.each { |locations|
        placeholders.copy(locations[:from], locations[:to])
      }
      UI.verbose "Template files were copied successfully"
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
          :to => File.join(structure.path, FileName.strings)
        },
        {
          :from => FilePath.source_template,
          :to => File.join(structure.path, "#{project_name.capitalize}.java")
        }
      ]
    end

    def placeholders
      @placeholders ||= initialize_placeholders
    end

    def initialize_placeholders
      Placeholders.new(
        :company_domain => company_domain,
        :project_name => project_name.capitalize
        )
    end

    def validate_args(args)
      name = args[:project_name]
      if name.nil? || name.empty?
        raise ArgumentError.new "Project should be initialized with 'project_name' parameter"
      end
      @project_name = name 
      @location = args[:location] || Dir.pwd
      @company_domain = args[:company_domain] || "com.company.#{project_name}"
    end

  end
end

require 'fileutils'
require_relative 'actions/project_structure'
