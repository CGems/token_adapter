# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "token_adapter/version"

Gem::Specification.new do |spec|
  spec.name          = "token_adapter"
  spec.version       = TokenAdapter::VERSION
  spec.authors       = ["wuminzhe"]
  spec.email         = ["wuminzhe@gmail.com"]

  spec.summary       = "An adapter of different tokens for exchange"
  spec.description   = "An adapter of different tokens for exchange"
  spec.homepage      = "https://github.com/wuminzhe"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "garnet_client", "~> 0.1.2"

  spec.add_dependency "faraday", "~> 0.9.2"
  spec.add_dependency 'bip44', '~> 0.2.14'
  spec.add_dependency 'moac', '0.4.9'
  spec.add_dependency 'garnet_client', '~> 0.1.10'
end
