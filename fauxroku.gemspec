# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fauxroku/version'

Gem::Specification.new do |gem|
  gem.name          = "fauxroku"
  gem.version       = Fauxroku::VERSION
  gem.authors       = ["Isaac Wolkerstorfer"]
  gem.email         = ["i@agnoster.net"]
  gem.description   = %q{Run heroku-style apps.}
  gem.summary       = %q{Heroku provides some excellent conventions for creating applications. Fauxroku allows you to run those applications directly.}
  gem.homepage      = "https://github.com/agnoster/fauxroku"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "foreman", ">= 0.60.0"
  gem.add_dependency "thor", ">= 0.16.0"
end
