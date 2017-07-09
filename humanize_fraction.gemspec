# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "humanize_fraction/version"

Gem::Specification.new do |spec|
  spec.name          = "humanize_fraction"
  spec.version       = HumanizeFraction::VERSION
  spec.authors       = ["Peter Graham"]
  spec.email         = ["peterghm@gmail.com"]

  spec.summary       = %q{Convert fractions to words, 3/5 => three fifths.}
  spec.description   = %q{Convert fractions to words, such as 3/5 to three fifths.}
  spec.homepage      = "https://github.com/6/humanize_fraction"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.3.0"

  spec.add_runtime_dependency "activesupport", ">= 4"
  spec.add_runtime_dependency "humanize", "~> 1.4"
  spec.add_runtime_dependency "numbers_and_words", "~> 0.11"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its", "~> 1.2"
end
