module Walle
  class FilePath

    def self.templates
      directory = File.join(File.dirname(__FILE__), "../#{DirectoryName.templates}")
      unless Dir.exist?(directory)
        UI.failure "Could not locate templates directory"
      end
      directory
    end
    
    def self.manifest_template
      template_for(FileName.manifest)
    end

    def self.build_configuration_template
      template_for(FileName.build_configuration)
    end

    def self.strings_template
      template_for(FileName.strings)
    end
    
    def self.source_template
      template_for(FileName.source_template)
    end

    private
    
    def self.template_for(file_name)
      File.join(templates, file_name)
    end

  end
end

require_relative 'file_names'
