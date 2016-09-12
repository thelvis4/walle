module Walle
  class Pack < BuildPhase
    
    attr_reader :args, :keystore
    
    def initialize(args)
      super args
      @args = args
    end

    def commands
      super
      
      create_dex_file

      create_APK
      sign_APK
      zip_align_APK
    end

    def build_phase_name
      'pack'
    end

    def keystore
      @keystore ||= initialize_keystore(args)
    end

    private

    def structure
      project.structure
    end

    def create_dex_file
      command = sdk.dx
      command << " --dex"
      command << " --verbose" if Environment.verbose?
      command << " --output=\"#{structure.path}/bin/classes.dex\""
      command << " \"#{structure.obj_path}\""
      command << " \"#{structure.lib_path}\""

      Runner.shell(command, 'Creating DEX file')
    end

    def create_APK
      command = "#{sdk.aapt} package"
      command << " -v" if Environment.verbose?
      command << " -f"
      command << " -M \"#{structure.manifest_path}\""
      command << " -S \"#{structure.res_path}\""
      command << " -I \"#{sdk.android_jar_path}\""
      command << " -F \"#{structure.unsigned_APK_path}\""
      command << " \"#{structure.bin_path}\""

      Runner.shell(command, 'Creating APK file')
    end

    def sign_APK
      command = sdk.jarsigner
      command << " -verbose" if Environment.verbose?
      command << " -keystore \"#{keystore.path}\""
      command << " -storepass \"#{keystore.storepass}\""
      command << " -keypass \"#{keystore.keypass}\""
      command << " -signedjar \"#{structure.signed_APK_path}\""
      command << " \"#{structure.unsigned_APK_path}\""
      command << " \"#{keystore.alias}\""

      Runner.shell(command, 'Signing APK file', true)
    end
    
    def zip_align_APK
      command = sdk.zipalign
      command << " -v" if Environment.verbose?
      command << " -f 4"
      command << " \"#{structure.signed_APK_path}\""
      command << " \"#{structure.APK_path}\""

      Runner.shell(command, 'Zip aligning APK file')

      delete_temporary_APKs
    end

    def initialize_keystore(args)
      if args[:keystore_path].nil?
        UI.verbose("No keystore path indicated")        
        path = structure.temp_keystore_path
        @keystore = Keystore.generate(path)
      else
        @keystore = Keystore.new(args)
      end
    end

    def delete_temporary_APKs
      delete_if_exists(structure.unsigned_APK_path)
      delete_if_exists(structure.signed_APK_path)
    end

  end


  require 'highline/import'

  class Keystore

    attr_reader :path, :storepass, :keypass, :alias

    def initialize(args)
      check_arguments(args)
    end

    def self.generate(file_path)
      storepass = 'storepass'
      keypass = 'keypass'
      store_alias = 'AndroidTestKey'

      if File.exist? file_path
        UI.verbose("Existing keystore will be used: #{file_path}")
      else
        UI.verbose("A temporary keystore will be generated")
        generate_key(file_path, storepass, keypass, store_alias)
      end

      Keystore.new(
        :keystore_path => file_path,
        :storepass => storepass,
        :keypass => keypass,
        :alias => store_alias
      )
    end

    private

    def self.generate_key(path, storepass, keypass, als)
      command = SDK.new.keytool
      command << " -genkeypair"
      command << " -validity 10000"
      command << " -dname \"#{create_dname}\""
      command << " -keystore \"#{path}\""
      command << " -storepass \"#{storepass}\""
      command << " -keypass \"#{keypass}\""
      command << " -alias \"#{als}\""
      command << " -keyalg RSA"
      command << " -v" if Environment.verbose?

      Runner.shell(command, 'Creating temporary keystore')
    end

    def self.create_dname
      [
        "CN=Unknown company",
        "OU=Unknown organisational unit",
        "O=Unknown organisation",
        "L=Unknown",
        "S=NA",
        "C=NA"
      ].join(', ')
    end

    def ask_storepass
      ask("Enter keystore storepass:  ") { |q| q.echo = "*"  }
    end

    def ask_keypass
      ask("Enter keystore keypass:  ") { |q| q.echo = "*"  }
    end

    def ask_alias
      ask("Enter keystore alias:  ") { |q| q.echo = true }
    end
      
    def check_arguments(args)
      @path = args[:keystore_path]
      check_passes(args)
      check_alias(args)
    end

    def check_passes(args)
      storepass = args[:storepass]
      @storepass = nil_or_empty?(storepass) ? ask_storepass : storepass

      keypass = args[:keypass]
      @keypass = nil_or_empty?(keypass) ? ask_keypass : keypass
    end

    def check_alias(args)
      store_alias = args[:alias]
      @alias = nil_or_empty?(store_alias) ? ask_alias : store_alias
    end

  end
end
