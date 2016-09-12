
module Walle

  @@project = nil

  def self.set_project(x)
    @@project = x
  end

  def self.project
    @@project
  end
  
end

require 'open3'


module Walle
  class Runner

    def run
      command = Command::General.new
      command.parse
      action = command.get_action
      Walle.set_project(action.get_project)
      action.run()
    end

    def self.shell(command, step_name = nil, no_print = false)
      # Compute step name
      name = step_name.nil? ? command.partition(" ").first : step_name
      
      UI.start_step(name)
      UI.shell command unless no_print

      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          puts line
        end
        
        while line = stderr.gets
          puts line
        end
        
        exit_status = wait_thr.value
        if exit_status.success?
          UI.step_succeeded(name)
        else
          UI.step_failed(name, stderr.read)        
        end
      end

    end
    
  end
end
