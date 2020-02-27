# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subjective/version'

Gem::Specification.new do |spec|
  spec.name = 'subjective'
  spec.version = Subjective::VERSION
  spec.authors = ['Tyler Guillen']
  spec.email = ['tyguillen@gmail.com']

  spec.summary = 'Expose well-defined contexts to your user-facing tools'
  spec.description = 'Expose well-defined contexts to your user-facing tools'
  spec.homepage = 'https://github.com/aastronautss'
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_development_dependency 'activemodel'
  spec.add_development_dependency 'dry-struct'
end
