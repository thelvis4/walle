require 'walle/project/project'
require 'walle/runner'
require 'walle/actions/action'
require 'walle/commands/command'
require 'walle/helpers/helpers'

module Walle

  def self.run
    runner = Runner.new
    runner.run()
  end
end
