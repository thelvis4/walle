module Walle
  class Project
    
    attr_reader :name, :path, :configuration
    attr_accessor :structure

    def initialize(path)
      validate_path(path)
      
      @path = path
      @configuration = load_configuration(path)
      @name = configuration.project_name
    end

    def structure
      @structure ||= ProjectStructure.new(path, configuration.company_domain, name)
    end

    private

    def validate_path(path)
      unless Dir.exist?(path)
        UI.failure("Indicated project path does not exist")
      end

      unless File.exist? path_to_build_configuration(path)
        UI.failure("Indicated path does not contain build configuration file.")
      end
    end

    def load_configuration(path)
      build_config_path = path_to_build_configuration(path)
      BuildConfiguration.load(build_config_path)
    end

    def path_to_build_configuration(project_path)
      File.join(project_path, FileName.build_configuration)
    end

  end
end

require_relative 'project_structure'
require_relative 'build_configuration'
require_relative 'project_generator'
