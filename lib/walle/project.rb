module Walle
  class Project
    
    attr_reader :path, :project_name, :company_domain
    attr_accessor :structure, :placeholders

    def initialize(args)
      validate_args args
    end

    def self.load(path)
      
    end

    def generate
      generate_project_folder
      generate_project_structure
      copy_templates

      UI.verbose "Project was successfully create at #{project_path}"
    end

    def project_path
      File.expand_path(File.join(path, project_name))
    end
    
    private
    
    def generate_project_folder
      UI.verbose "Create project folder"
      FileUtils.mkdir_p project_path
    end

    def generate_project_structure
      self.structure = ProjectStructure.new(project_path, company_domain)
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
          :to => File.join(project_path, FileName.build_configuration)
        },
        {
          :from => FilePath.manifest_template,
          :to => File.join(project_path, FileName.manifest) 
        },
        {
          :from => FilePath.strings_template,
          :to => File.join(structure.values_path, FileName.strings)
        },
        {
          :from => FilePath.source_template,
          :to => File.join(structure.package_path, "#{project_name.capitalize}.java")
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
      @path = args[:path] || Dir.pwd
      @company_domain = args[:company_domain] || "com.company.#{project_name}"
    end

  end
end

require 'fileutils'
require_relative 'actions/project_structure'
