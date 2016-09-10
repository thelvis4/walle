# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'walle/version'

Gem::Specification.new do |s|
  s.name        = 'walle'
  s.version     = Walle::VERSION
  s.summary     = "A simple Android build system."
  s.description = "walle is a nice CLI that serves as an Android build system. It can create a project, compile it, create and sign the APK package and deploy it on a emulator."
  s.authors     = ['Andrei Raifura']
  s.email       = 'thelvis4@gmail.com'
  s.homepage    = 'https://github.com/thelvis4/walle'
  s.license     = 'MIT'

  s.files       = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  
  s.require_paths = ["lib"]
  s.executables << "walle"

  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"

end