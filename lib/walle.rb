require 'walle/project'
require 'walle/runner'
require 'walle/actions/action'
require 'walle/commands/command'
require 'walle/helpers/extensions'
require 'walle/helpers/placeholders'
require 'walle/helpers/sdk'
require 'walle/helpers/ui'
require 'walle/helpers/environment'
require 'walle/helpers/args_validator'
require 'walle/helpers/file_path'


module Walle

  def self.run
    runner = Runner.new
    runner.run()
  end
end
