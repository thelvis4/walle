module Walle
  module Command
    class Create < Command

      attr_accessor :args

      def initialize(args)
        @args = args
        @options = {}
      end

      def parse_args
        @opt_parser = OptionParser.new do |opt|
          opt.banner = "Usage: walle create [OPTIONS]"
          opt.separator ""
          opt.separator "Options:"

          opt.on("-n", "--name NAME", "Project name") do |name|
            options[:project_name] = name
          end

          opt.on("-p", "--path LOCATION", "Specifies the location where the project will be created") do |path|
            options[:path] = path
          end
          
          opt.on("-d", "--company-domain DOMAIN", "A reverse DNS identifying the project") do |domain|
            options[:company_domain] = domain
          end

          opt.on("-v", "--verbose", "Run verbosely") do
            ENV['VERBOSE'] = 'true'
          end

          opt.on("-h","--help", "") do
            puts opt_parser
            exit(0)
          end
        end

        opt_parser.parse!(args)
      end

      def parse
        begin
          parse_args

        rescue => e
          puts e
          exit(1)
        end
      end

      def get_action
        Walle::Create.new(options)
      end

    end
  end
end
