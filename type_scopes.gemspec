# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'type_scopes/version'

Gem::Specification.new do |spec|
  spec.name          = "type_scopes"
  spec.version       = TypeScopes::VERSION
  spec.authors       = ["Alexis Bernard"]
  spec.email         = ["alexis@bernard.io"]
  spec.summary       = "Semantic scopes for your ActiveRecord models."
  spec.description   = "Automatically create semantic scopes based on columns' types (dates, times, strings and numerics)."
  spec.homepage      = "https://github.com/BaseSecrete/type_scopes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
