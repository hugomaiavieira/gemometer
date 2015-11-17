# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemometer/version'

Gem::Specification.new do |spec|
  spec.name          = "gemometer"
  spec.version       = Gemometer::VERSION
  spec.authors       = ["Hugo Maia Vieira"]
  spec.email         = ["hugomaiavieira@gmail.com"]

  spec.summary       = %q{Verify and notify about outdated dependencies based on project's Gemfile}
  spec.description   = %q{Gemometer is intended to be used on your continuous integration server to notify when there are new versions of the gems used on your project.}
  spec.homepage      = "https://github.com/hugomaiavieira/gemometer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22"
  spec.add_development_dependency "rspec"
end
