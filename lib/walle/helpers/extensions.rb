require 'fileutils'

class String
  def write_to_file(file_path)
    # Create containing  directory if it doesn't exist
    dir = File.dirname(file_path)
    unless Dir.exist?(dir)
      FileUtils.mkdir_p dir
    end
    # Write file into directory
    File.open(file_path, "w") { |file| file.puts self }
  end

  def to_bool
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

end