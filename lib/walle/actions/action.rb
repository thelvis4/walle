module Walle
  class Action
    
    def initialize(args={})
    end

    def run
      validate_prerequisites
    end

    def validate_prerequisites
      SDK.new.validate
    end

  end
end

require_relative 'build_phase'
require_relative 'create'
require_relative 'compile'
require_relative 'pack'
require_relative 'deploy'
