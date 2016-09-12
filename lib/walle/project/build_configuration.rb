module Walle
  class BuildConfiguration
    
    attr_reader :company_domain, :project_name, :scripts

    def initialize(args)
      validate_args args

      @company_domain = args[:company_domain]
      @project_name = args[:project_name]
      @scripts = parse_scripts(args[:scripts])
    end

    def self.load(file_path)
      file = File.read(file_path)
      data = JSON.parse(file)

      BuildConfiguration.new(
        :company_domain => data['company_domain'],
        :project_name => data['name'],
        :scripts => data['scripts']
      )
    end

    def run_script_before(action)
      script = scripts[action]
      return if script.nil?
      script.run_before
    end

    def run_script_after(action)
      script = scripts[action]
      return if script.nil?
      script.run_after
    end

    def package_name
      package_name_for_domain_and_project(company_domain, project_name)
    end

    private

    def validate_args(args)
      [:company_domain, :project_name].each { |key|
        Args.validate_for_key(args, key, self.class.name)
      }
    end

    def parse_scripts(hash)
      return {} if hash.nil? || hash.empty?

      scripts = {}

      hash.each do |key, value|
        before = value['before']
        after = value['after']
        unless nil_or_empty?(before) && nil_or_empty?(after)
          pair = BuildScripts.new(before, after, key)
          scripts[key] = pair
        end
      end
      
      scripts
    end

  end

  class BuildScripts
     
    attr_reader :before, :after, :phase_name

    def initialize(before = nil, after = nil, phase_name = 'Build phase')
      @before = before
      @after = after
      @phase_name = phase_name
    end

    def run_before
      return if before.nil?
      Runner.shell(before, "pre #{phase_name} script")
    end

    def run_after
      return if after.nil?
      Runner.shell(after, "post #{phase_name} script")
    end

    def make_shell_command(script)

    end

  end

end

require 'json'
