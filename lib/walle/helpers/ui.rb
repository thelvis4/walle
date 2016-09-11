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
    
  end
end