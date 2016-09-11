
module Walle

  @@project = nil

  def self.set_project(x)
    @@project = x
  end

  def self.project
    @@project
  end
  
end

module Walle
  class Runner

    def run
      command = Command::General.new
      command.parse
      action = command.get_action
      Walle.set_project(action.get_project)
      action.run()
    end

    def self.shell(command, step_name = nil)
      # Compute step name
      name = step_name.nil? ? command.partition(" ").first : step_name
      
      UI.start_step(name)
      UI.shell command

      begin
        system(command)
      rescue => e
        step_failed(name, e)
      else
        UI.step_succeeded(name)
      end
    end
    
  end
end
