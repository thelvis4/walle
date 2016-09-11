module Walle
  class BuildConfiguration
    
    attr_reader :company_domain, :project_name
    
    def initialize(args)
      validate_args args

      @company_domain = args[:company_domain]
      @project_name = args[:project_name]
    end

    def self.load
    end

    private

    def validate_args(args)
      [:company_domain, :project_name].each { |key|
        Args.validate_for_key(args, key, self.class.name)
      }
    end

  end
end
