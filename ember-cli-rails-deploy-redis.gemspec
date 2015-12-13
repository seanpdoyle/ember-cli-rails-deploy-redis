# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ember-cli/deploy/version"

Gem::Specification.new do |spec|
  spec.name          = "ember-cli-rails-deploy-redis"
  spec.version       = EmberCLI::Deploy::VERSION
  spec.authors       = ["Sean Doyle"]
  spec.email         = ["sean.p.doyle24@gmail.com"]

  spec.summary       = %q{Lightning Fast deploys with ember-cli-rails}
  spec.description   = %q{Lightning Fast deploys with ember-cli-rails}
  spec.homepage      = "https://github.com/seanpdoyle/ember-cli-rails-deploy-redis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.1", "< 5"
  spec.add_dependency "redis", ">= 3.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "fakeredis"
  spec.add_development_dependency "pry"
end
