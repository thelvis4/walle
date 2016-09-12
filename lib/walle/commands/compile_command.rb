module Walle
  module Command
    class Compile < Command

      attr_accessor :args

      def initialize(args)
        @args = args
        @options = {}
      end

      def parse_args
        @opt_parser = OptionParser.new do |opt|
          opt.banner = "Usage: walle compile [OPTIONS]"
          opt.separator ""
          opt.separator "Options:"

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
        Walle::Compile.new(options)
      end

    end
  end
end
