module Walle
  class SDK

    def validate
      unless is_set_android_home?
        UI.failure "ANDROID_HOME environment variable is not set. Please set it using `export ANDROID_HOME=/path/to/android/sdk`."
        false
      end

      validate_subdirectories
    end

    def is_set_android_home?
      !android_home.nil? && !android_home.empty?
    end

    def validate_subdirectories
      false unless Dir.exist?(android_home)
      subdirectories.all? { |subdir| 
        unless Dir.exist?(path_to subdir)
          UI.failure "'#{android_home}' is not a correct path for ANDROID_HOME. '#{subdir}' directory is missing."
        end
        true
      }
    end

    def subdirectories
      [build_tools, tools, platform_tools]
    end

    def android_home
      @android_home ||= Environment.android_home
    end

    def build_tools
      'build-tools'
    end

    def tools
      'tools'
    end

    def platform_tools
      'platform-tools'
    end


    def path_to(subdir)
      File.join(android_home, subdir)
    end

  end
end
    