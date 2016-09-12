module Walle 
  module Command
    class Command
      attr_accessor :options, :opt_parser

      def initialize()
        @options = {}
      end

      def parse
      end

      def get_action
      end

    end
  end
end 

require 'optparse'

require_relative 'general_command'
require_relative 'create_command'
require_relative 'compile_command'
require_relative 'pack_command'
require_relative 'deploy_command'
