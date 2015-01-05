lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zombie_epidemic/version'

Gem::Specification.new do |spec|
  spec.name          = 'zombie_epidemic'
  spec.version       = ZombieEpidemic::VERSION
  spec.date          = '2014-12-19'
  spec.authors       = ['Christophe Philemotte']
  spec.email         = ['christophe.philemotte@8thcolor.com']
  spec.summary       = %q{ABM Simulation of Zombie Disease.}
  spec.description   = %q{ABM Simulation of Zombie Disease.}
  spec.homepage      = 'https://github.com/toch/zombie_epidemic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'turn'
  spec.add_dependency 'chunky_png'
end