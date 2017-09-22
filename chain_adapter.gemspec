# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chain_adapter/version"

Gem::Specification.new do |spec|
  spec.name          = "chain_adapter"
  spec.version       = ChainAdapter::VERSION
  spec.authors       = ["wuminzhe"]
  spec.email         = ["wuminzhe@gmail.com"]

  spec.summary       = "A adapter for different block chain"
  spec.description   = "A adapter for different block chain"
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
  spec.add_dependency "pattern-match", "1.0.1"
  spec.add_dependency "eth", "0.4.4"
  spec.add_dependency "etherscan", "0.1.3"

end
