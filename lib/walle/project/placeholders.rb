module Walle
  class Placeholders
    
    attr_reader :company_domain, :project_name
    
    def initialize(args)
      validate_args(args)
      assign_args(args)
    end

    def copy(source_path, destination_path)
      contents = read_contents(source_path)
      replace(contents)
      contents.write_to_file(destination_path)
      UI.verbose "Copied #{File.basename(destination_path)}"
    end

    def replace(contents)
      if contents.nil?
        UI.error "Empty contents given"
        return nil
      end

      contents.gsub!("COMPANY_DOMAIN", company_domain)
      contents.gsub!("PROJECT NAME", project_name)
      contents.gsub!("PROJECT_NAME", project_name.no_spaces)
      contents.gsub!("PACKAGE_NAME", package_name)

      contents
    end

    private

    def package_name
      package_name_for_domain_and_project(company_domain, project_name)
    end

    def read_contents(file_path)
      if !File.exists?(file_path)
        UI.failure "There is no file at path #{file_path}"
      end
      contents = File.read(file_path)
      if contents.nil?
        UI.failure "Could not read contents from #{file_path}"
      end 
      contents
    end

    def validate_args(args)
      [:company_domain, :project_name].each { |key|
        Args.validate_for_key(args, key, self.class.name)
      }
    end

    def assign_args(args)
      @company_domain = args[:company_domain]
      @project_name = args[:project_name]
    end

  end
end
