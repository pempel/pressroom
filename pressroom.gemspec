# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "pressroom/version"

Gem::Specification.new do |spec|
  spec.name        = "pressroom"
  spec.version     = Pressroom::VERSION
  spec.authors     = ["Eugene Pempel"]
  spec.email       = ["pempel@cleverbits.co"]
  spec.summary     = "Release! Release! Release!"
  spec.description = "Release! Release! Release!"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "github_api", "~> 0.14.0"
  spec.add_dependency "github_changelog_generator", "1.12.1"
  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry-byebug", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
