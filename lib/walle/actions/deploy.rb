module Walle
  class Deploy < BuildPhase
    
    attr_reader :args
    
    def commands
      super

      deploy_on_emulator
    end

    def build_phase_name
      'deploy'
    end

    private

    def structure
      project.structure
    end
    
    def package_name
      project.configuration.package_name
    end

    def deploy_on_emulator
      if app_installed?
        UI.verbose "Package #{package_name} is already installed. We have to uninstall it first."
        uninstall_package(package_name)
      end

      install_app
    end
   
    def install_app
      command = sdk.adb
      command << " -e"
      command << " install \"#{structure.APK_path}\""

      Runner.shell(command, 'Installing APK on emulator')
    end

    def uninstall_package(package)
      command = sdk.adb
      command << " -e"
      command << " uninstall \"#{package}\""

      Runner.shell(command, "Uninstalling #{package}")
    end

    def app_installed?
      installed_packages.include? package_name
    end

    def installed_packages
      packages = `#{sdk.adb} shell pm list packages`

      # Remove 'package:' in front of each line
      packages.lines.map { |p| p.gsub('package:', '').strip }
    end

  end
end
