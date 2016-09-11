
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

  end
end