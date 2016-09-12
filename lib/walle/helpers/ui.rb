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
      verbose(command)
    end

    def self.start_step(step)
      message(" => #{step}")
    end

    def self.step_succeeded(step)
      verbose(" => #{step.capitalize} succeeded\n\n")
    end
    
    def self.step_failed(step, error = nil)
      message(" => #{step.capitalize} failed\n")
      message("Error:\n#{error}\n\n") unless nil_or_empty?(error)
      failure(error)
    end

  end
end
