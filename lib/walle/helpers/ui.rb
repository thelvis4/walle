require 'colorize'

module Walle
  class UI

    def self.message(text)
      unless Environment.test?
        puts "#{text}"
      end
    end

    def self.verbose(text)
      message(text) if Environment.verbose?
    end

    def self.error(text)
      message(text)
    end

    def self.failure(text)
      abort(text)
      exit(1)
    end

    def self.argument_error(text)
      raise ArgumentError.new text
    end

    def self.shell(command)
      verbose("$ #{command}".light_black)
    end

    def self.start_step(step)
      verbose("=> #{step}")
    end

    def self.step_succeeded(step)
      message = "#{step.capitalize} succeeded\n".green
      verbose(message)
    end
    
    def self.step_failed(step, error = nil)
      message = "#{step.capitalize} failed\n".light_red
      message(message)
      failure(error.red)
    end

    def self.finish_action(text)
      message(text.light_green)
    end

    def self.start_action(text)
      message(text)
    end

  end
end
