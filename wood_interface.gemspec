lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wood_interface/version"

Gem::Specification.new do |spec|
  spec.name          = "wood_interface"
  spec.version       = WoodInterface::VERSION
  spec.authors       = ["woodcrust"]
  spec.email         = ["emptystamp@gmail.com"]

  spec.summary       = %q{This is interface}
  spec.description   = %q{WOOD INTERFACE.}
  spec.homepage      = "https://github.com/woodcrust/wood_interface"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*']
  spec.bindir        = "bin"
  spec.executables   = ["wood_interface"]
  spec.require_paths = ["lib"]

  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rspec", "~> 3.0"
end