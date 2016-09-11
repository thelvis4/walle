module Walle
  class Create < Action

    attr_reader :args, :project

    def initialize(args)
      super args
      @args = args
    end

    def run
      super
      @project = Project.new(args)
      project.generate()
    end

    def get_project
      project
    end

  end
end
