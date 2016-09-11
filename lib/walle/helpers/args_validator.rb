module Walle
  class Args

    def self.validate(argument, key, class_name = nil)
      if argument.nil?
        UI.argument_error message_for_nil(class_name)
      end

      if argument.empty?
        UI.argument_error message_for_empty(class_name)
      end 
    end

    def self.validate_for_key(args, key, class_name = nil)
      argument = args[key]

      validate(argument, key, class_name)
    end

    private

    def self.message_for_nil(key, class_name)
      message = "No parameter passed for '#{key}'"
      append_class_name(message, class_name)
    end

    def self.message_for_empty(key, class_name)
      message = "Passed invalid parameter for '#{key}'"
      append_class_name(message, class_name)
    end

    def self.append_class_name(message, class_name)
      message << class_name.nil? ? "" : " in #{class_name}"
    end
  end
end