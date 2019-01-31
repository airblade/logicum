
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "logicum/version"

Gem::Specification.new do |spec|
  spec.name          = "logicum"
  spec.version       = Logicum::VERSION
  spec.authors       = ["Andy Stewart"]
  spec.email         = ["boss@airbladesoftware.com"]

  spec.summary       = 'Simplifies writing a unit of business logic.'
  spec.homepage      = 'https://github.com/airblade/logicum'
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
