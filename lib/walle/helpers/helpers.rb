require_relative 'extensions'
require_relative 'sdk'
require_relative 'ui'
require_relative 'environment'
require_relative 'args_validator'
require_relative 'file_path'

require 'fileutils'
require 'pathname'

def copy_with_path(src, dst)
  FileUtils.mkdir_p(File.dirname(dst))
  FileUtils.cp(src, dst)
end

def path_relative_to_path(path, relative)
  relative_pathname = Pathname.new(relative)
  Pathname.new(path).relative_path_from(relative_pathname).to_s
end

def find_files(base_path)
  Dir["#{base_path}/**/*"].select { |file| File.file?(file) }
end

def delete_if_exists(path_to_file)
  File.delete(path_to_file) if File.exist?(path_to_file)  
end

def nil_or_empty?(value)
  value.nil? || value.empty?
end

def package_name_for_domain_and_project(domain, project_name)
  "#{domain}.#{project_name.no_spaces.downcase}"
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
