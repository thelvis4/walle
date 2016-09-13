module Walle
  class Environment

    def self.android_home
      ENV['ANDROID_HOME']
    end

    def self.is_set_android_home?
      !nil_or_empty?(android_home)
    end

    def self.java_home
      ENV['JAVA_HOME']
    end

    def self.is_set_java_home?
      !nil_or_empty?(java_home)
    end

    def self.verbose?
      verbose = ENV['VERBOSE']
      verbose.nil? ? false : verbose.to_bool
    end

    def self.test?
      is_test = ENV['TEST']
      is_test.nil? ? false : is_test.to_bool
    end
  end
end
