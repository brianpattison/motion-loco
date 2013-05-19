# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-loco/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "motion-loco"
  spec.version       = Loco::VERSION
  spec.authors       = ["Brian Pattison"]
  spec.email         = ["brian@brianpattison.com"]
  spec.description   = %q{Library for RubyMotion that includes Ember.js-like bindings, computed properties, and observers.
                          Loco also includes a set of views that are easier to position and size.}
  spec.summary       = %q{Library for RubyMotion that includes Ember.js-like bindings, computed properties, and observers.}
  spec.homepage      = "https://github.com/brianpattison/motion-loco"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "motion-redgreen", "~> 0.1.0"
  spec.add_dependency "motion-require", "~> 0.0.6"
  spec.add_development_dependency "rake"
end
