module Walle
  class SDK

    attr_reader :android_home, :java_home, :platform, :platform_specific_tools_path

    def validate
      unless Environment.is_set_android_home?
        UI.failure "ANDROID_HOME environment variable is not set. Please set it using `export ANDROID_HOME=/path/to/android/sdk`."
        false
      end

      validate_subdirectories
    end

    def validate_subdirectories
      false unless Dir.exist?(android_home)
      subdirectories.all? { |subdir| 
        unless Dir.exist?(subdir)
          UI.failure "'#{android_home}' is not a correct path for ANDROID_HOME. '#{subdir}' directory is missing."
        end
        true
      }
    end

    def subdirectories
      [build_tools_path, tools_path, platform_tools_path]
    end

    def android_home
      @android_home ||= Environment.android_home
    end

    def java_home
      @java_home ||= find_java_home
    end

    def build_tools_path
      File.join(android_home, 'build-tools')
    end
    
    def tools_path
      File.join(android_home, 'tools')
    end

    def platform_tools_path
      File.join(android_home, 'platform-tools')
    end

    def android
      File.join(tools_path, 'android')
    end

    def aapt
      File.join(platform_specific_tools_path, 'aapt')
    end

    def dx
      File.join(platform_specific_tools_path, 'dx')
    end

    def zipalign
      File.join(platform_specific_tools_path, 'zipalign')
    end

    def adb
      File.join(platform_tools_path, 'adb')
    end

    def parse_available_platforms(output)
      [] if output.nil? || output.empty?

      output.lines.map { |line| line.strip }
    end

    def available_platforms
      command = "#{android} list target --compact"
      output = `#{command}`
      parse_available_platforms(output)
    end

    def platform
      @platform ||= choose_platform  
    end

    def platform_specific_tools_path
      @platform_specific_tools_path ||= find_platform_specific_tools_path
    end

    def android_jar_path
      File.join(android_home, 'platforms', platform, 'android.jar')
    end

    def javac
      find_executable_in_java_bin('javac')
    end

    def keytool
      find_executable_in_java_bin('keytool')
    end

    def jarsigner
      find_executable_in_java_bin('jarsigner')
    end

    private

    def find_executable_in_java_bin(executable_name)
      path = which(executable_name)
      return path unless path.nil?
        
      UI.verbose "#{executable_name} could not be found in $PATH"

      UI.verbose "Looking for $JAVA_HOME environment variable"
      
      file_path = File.join(java_home, 'bin', executable_name)
      unless File.exist?(file_path)
        UI.failure "Could not find '#{executable_name}' executable"
      end

      file_path
    end

    def find_java_home
      java_home = Environment.java_home

      unless Environment.is_set_java_home?
        UI.verbose "$JAVA_HOME environment variable is not set"
        UI.failure "Please set $JAVA_HOME and try again."
      else
        java_home
      end
    end

    def find_platform_specific_tools_path
      platform_number = platform.gsub('android-', '')
      regex = "#{build_tools_path}/#{platform_number}*"
      folders = Dir.glob(regex)

      if folders.empty? 
        UI.failure "There are no folder for platform #{platform} in #{build_tools_path}"
      end

      folders.first
    end

    def choose_platform
      platforms = available_platforms
      UI.failure "There are no available target platform." if platforms.empty?

      platforms.sort! {|x, y| y <=> x}
      chosen = platforms.first
      UI.verbose "Will use '#{chosen}' platform"

      chosen
    end

  end
end
