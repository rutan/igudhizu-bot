# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/igudhizu/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-igudhizu"
  spec.version       = Ruboty::Igudhizu::VERSION
  spec.authors       = ["Ru/MuckRu"]
  spec.email         = ["ru_shalm@hazimu.com"]
  spec.summary       = %q{igudhizu_bot by ruboty}
  spec.description   = %q{igudhizu_bot by ruboty}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'ruboty', '~> 1.2.1'
  spec.add_dependency 'mongoid', '~> 5.0.0'
  spec.add_dependency 'okura', '~> 0.0.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
