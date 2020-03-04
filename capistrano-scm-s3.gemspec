# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/scm/s3/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-scm-s3"
  spec.version       = Capistrano::Scm::S3::VERSION
  spec.authors       = ["catalin gheonea"]
  spec.email         = ["catalin.gheonea@gmail.com"]

  spec.summary       = %q{SCM S3 for Capistrano 3}
  spec.description   = %q{Use Capistrano 3 with S3 as SCM}
  spec.homepage      = "https://github.com/tarrynn/capistrano-scm-s3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17.1"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "capistrano", "~> 3.7"
end
