# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'niffler/version'

Gem::Specification.new do |gem|
  gem.name          = "niffler"
  gem.version       = Niffler::VERSION
  gem.authors       = ["Michael Carlson"]
  gem.email         = ["me@mbcarlson.org"]
  gem.description   = %q{A tool for getting software metadata from various online tools}
  gem.summary       = %q{ This gem will fetch information about software based on the SHA1 hash } +
      %q{ of the jar. }
  gem.homepage      = "https://github.com/Prandium/niffler"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version     = '>= 1.9.2'

  gem.add_dependency('rack-client')
  gem.add_dependency('excon')
  gem.add_dependency('celluloid')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('sinatra')
  gem.add_development_dependency('realweb')
  gem.add_development_dependency('awesome_print')
  gem.add_development_dependency('colorize')
end
