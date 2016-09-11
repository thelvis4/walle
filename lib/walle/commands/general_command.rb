module Walle
  module Command
    class General < Command
      
      attr_accessor :command
      
      def parse_args
        @opt_parser = OptionParser.new do |opt|
          opt.banner = "Usage: walle COMMAND [OPTIONS]"
          opt.separator ""
          opt.separator "Commands"
          opt.separator "     create:   Create a new Android project"
          opt.separator "     compile:  Compile the project"
          opt.separator "     pack:     Generate and sign APK package"
          opt.separator "     deploy:   Install APK package on the active emulator"
          opt.separator ""
          opt.separator "General options:"

          opt.on("-h","--help", "Print command's help") do
            puts opt_parser
            exit(0)
          end
        end

        opt_parser.parse
      end

      def parse
        parse_args
        args = ARGV.clone
        command_option = args.shift
        
        command_class = get_command_class(command_option)

        unless command_class.nil?
          @command = command_class.new args
          command.parse
        else
          puts "Unknown command #{command_option}"
          puts opt_parser
          exit(1)
        end
      end
      
      def get_action
        command.get_action
      end

      private

      def get_command_class(option)
        case option
        when 'create'
          Create
        when 'compile'
          Copile
        when 'pack'
          Pack
        when 'deploy'
          Deploy
        end
      end
      
    end
  end
end
