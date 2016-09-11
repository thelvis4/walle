module Walle
  class SDK

    attr_reader :platform, :platform_specific_tools_path

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

    def parse_available_platforms(string)
      [] if string.nil? || string.empty?

      string.lines.map { |line| line.strip }
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
      find_javac
    end

    private

    def find_javac
      path = which('javac')
      return path unless path.nil?
        
      UI.verbose "javac could not be found in $PATH"
      UI.verbose "Looking for $JAVA_HOME environment variable"

      java_home = Environment.java_home

      if Environment.java_home.nil? || Environment.java_home.empty?
        UI.verbose "$JAVA_HOME environment variable is not set"
        UI.failure "Could not find 'javac'. Please set $JAVA_HOME and try again."
      else
        file_path = File.join(java_home, 'bin', 'javac')
        return file_path if File.exist?(file_path)

        UI.failure "Could not find 'javac' executable"
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

    # Cross-platform way of finding an executable in the $PATH.
    #
    #   which('ruby') #=> /usr/bin/ruby
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      return nil
    end

  end
end
