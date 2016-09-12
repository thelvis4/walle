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

    def get_project
      UI.failure "Cannot generate the project from an abstract Action class"  
    end

  end
end

require_relative 'build_phase'
require_relative 'create'
require_relative 'compile'
require_relative 'pack'
