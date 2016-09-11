module Walle
  class Compile < BuildPhase

    def commands
      super
      
      generate_R_file
      compile
      copy_non_java_files
      create_dex_file
    end

    def build_phase_name
      'compile'
    end

    private

    def structure
      project.structure
    end

    def generate_R_file
      command = "#{sdk.aapt} package -v -f -m"
      command << " -S #{structure.res_path}"
      command << " -J #{structure.src_path}"
      command << " -M #{structure.manifest_path}"
      command << " -I #{sdk.android_jar_path}"
      
      Runner.shell(command, 'Generating R file')
    end

    def compile
      command = sdk.javac
      
      # '-source 1.7 -target 1.7' should be added in order
      # to avoid "javac: target release 1.7 conflicts with
      # default source release 1.8" and 
      # "Dx unsupported class file version 52.0" eventually.
      # 
      # This ends up with 'bootstrap class path not set in 
      # conjunction with -source 1.7' warning, but this is
      # the fast solution that was found for now
      command << " -source 1.7 -target 1.7"

      command << " -d #{structure.obj_path}"
      command << " -classpath #{sdk.android_jar_path}:#{structure.obj_path}"
      command << " -sourcepath #{structure.src_path}"
      command << " #{structure.package_path}/*.java"

      Runner.shell(command)
    end

    def create_dex_file
      command = sdk.dx
      command << " --dex"
      command << " --output=#{structure.path}/bin/classes.dex"
      command << " #{structure.obj_path}"
      command << " #{structure.lib_path}"

      Runner.shell(command)
    end

    def copy_non_java_files
      files = find_non_java_files
      copy_files_to_obj(files)
    end

    def find_non_java_files
      src_path = structure.src_path
      files = find_files(src_path)
      non_java_paths = files.reject { |file| file.end_with?(".java") }
    end

    def copy_files_to_obj(files)
      obj_path = structure.obj_path
      src_path = structure.src_path

      files.each { |path|
        relative = path_relative_to_path(path, src_path)
        dest = File.join(obj_path, relative)
        copy_with_path(path, dest)
      } 
    end

  end
end
