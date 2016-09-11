require 'walle'
require 'fileutils'

ENV['TEST'] = "true"

def temporary_dir
  tmp_dir = File.join(File.dirname(__FILE__), '.tmp')

  unless Dir.exist?(tmp_dir)
    FileUtils.mkdir_p(tmp_dir)
  end

  tmp_dir
end

def clear_temporary_dir
  FileUtils.rm_rf Dir.glob("#{temporary_dir}/*")
end