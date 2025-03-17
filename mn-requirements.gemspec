lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "metanorma/requirements/version"

Gem::Specification.new do |spec|
  spec.name          = "mn-requirements"
  spec.version       = Metanorma::Requirements::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "Requirements processing and rendering according to different models"
  spec.description   = <<~DESCRIPTION
    Requirements processing and rendering according to different models
  DESCRIPTION

  spec.homepage      = "https://github.com/metanorma/mn-requirements"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|bin|.github)/}) \
    || f.match(%r{Rakefile|bin/rspec})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  # precise version is on relaton-render
  spec.add_dependency "isodoc-i18n", ">= 1.1.0"
  spec.add_dependency "metanorma-utils", ">= 0.10.0"
  spec.add_dependency "relaton-render", ">= 0.9.0"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "equivalent-xml", "~> 0.6"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "metanorma-standoc", ">= 2.8.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rubocop", "~> 1"
spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "sassc-embedded", "~> 1"
  spec.add_development_dependency "simplecov", "~> 0.15"
  spec.add_development_dependency "timecop", "~> 0.9"
  spec.add_development_dependency "xml-c14n"
end
