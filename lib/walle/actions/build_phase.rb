module Walle
  class BuildPhase < Action

    attr_reader :args, :project, :sdk

    def initialize(args)
      super args

      @args = args
      @project = Project.new(project_path)
      @sdk = SDK.new
    end

    def run
      super
      before_run
      commands
      after_run
    end

    def get_project
      project
    end

    def build_phase_name
      'build'
    end

    def before_run
      project.configuration.run_script_before(build_phase_name.downcase)
    end

    def commands
    end

    def after_run
      project.configuration.run_script_after(build_phase_name.downcase)
    end

    private
    
    # For now all the build phases are run from project's root folder.
    def project_path
      Dir.pwd
    end

  end
end
