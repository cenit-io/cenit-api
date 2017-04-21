lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cenit/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'cenit-api'
  spec.version       = Cenit::API::VERSION
  spec.authors       = ['Maikel Arcia']
  spec.email         = ['macarci@gmail.com']

  spec.summary       = %q{A Ruby client to interact with a Cenit API.}
  spec.description   = %q{Provides a Ruby client to interact with a Cenit API using a DSL to route your resources and to build queries and options for result rendering.}
  spec.homepage      = 'https://cenit.io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'cenit-config', '~> 0.0.1'
  spec.add_runtime_dependency 'hashie', '~> 3.4', '>= 3.4.3'
  spec.add_runtime_dependency 'httparty', '~> 0.13.7'
  spec.add_runtime_dependency 'origin', '~> 2.1', '>= 2.1.1'
end
