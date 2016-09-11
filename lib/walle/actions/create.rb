module Walle
  class Create < Action

    attr_reader :args, :project

    def initialize(args)
      super args
      @args = args
    end

    def run
      generator = ProjectGenerator.new(args)
      generator.generate()
    end

    def get_project
      nil
    end

  end
end
