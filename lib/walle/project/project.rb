module Walle
  class Project
    
    attr_reader :name, :path, :configuration
    attr_accessor :structure

    def initialize(path)
      Project.validate_path(path)
      
      @path = path
      @configuration = load_configuration(path)
      @name = configuration.project_name
    end

    def structure
      @structure ||= ProjectStructure.new(path, configuration.company_domain, name)
    end

    private

    def self.validate_path(path)
      unless Dir.exist?(path)
        UI.failure("Indicated project path does not exist")
      end

      unless File.exist? path_to_build_configuration(path)
        error = [
          "Working directory does not contain any build configuration file.",
          "Please add a build configuration file in project's root folder or create a new project using `walle create` command."
        ]
        UI.failure(error.join("\n"))
      end
    end

    def self.path_to_build_configuration(project_path)
      File.join(project_path, FileName.build_configuration)
    end
    
    def load_configuration(path)
      build_config_path = Project.path_to_build_configuration(path)
      BuildConfiguration.load(build_config_path)
    end

  end
end

require_relative 'project_structure'
require_relative 'build_configuration'
require_relative 'project_generator'
require_relative 'placeholders'

