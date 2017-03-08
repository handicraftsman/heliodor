# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heliodor/version'

Gem::Specification.new do |spec|
  spec.name          = 'heliodor'
  spec.version       = Heliodor::VERSION
  spec.authors       = ['Nickolay']
  spec.email         = ['nickolay02@inbox.ru']

  spec.summary       = 'NoSQL Server-Less DB-library'
  spec.description   = 'NoSQL Server-Less DB-library'
  spec.homepage      = 'https://github.com/handicraftsman/heliodor/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'

  spec.add_runtime_dependency 'bson', '~> 4.0'
end
