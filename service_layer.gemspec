# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_layer/version'

Gem::Specification.new do |spec|
  spec.name          = "service_layer"
  spec.version       = ServiceLayer::VERSION
  spec.authors       = ["Lance Woodson"]
  spec.email         = ["lance@webmaneuvers.com"]
  spec.summary       = %q{Frameworky support for a service layer in rails app}
  spec.description   = %q{Provides a service layer framework for rails apps as they need such things}
  spec.homepage      = "https://github.com/lwoodson/service_layer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "pry-byebug", "~> 1.3"
  spec.add_development_dependency "rails"
end
