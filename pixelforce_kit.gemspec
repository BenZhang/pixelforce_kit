# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pixelforce_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "pixelforce_kit"
  spec.version       = PixelforceKit::VERSION
  spec.authors       = ["Ben Zhang"]
  spec.email         = ["bzbnhang@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/BenZhang/pixelforce_kit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "elbas"
  spec.add_dependency 'devise'
  spec.add_dependency 'devise_token_auth'
  spec.add_dependency 'rswag-api'
  spec.add_dependency 'rswag-ui'
  spec.add_dependency 'rswag-specs'
  spec.add_dependency(%q<capistrano>, ["> 3.0.0"])
end
