# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mpesa_connect/version"

Gem::Specification.new do |spec|
  spec.name          = "mpesa_connect"
  spec.version       = MpesaConnect::VERSION
  spec.authors       = ["mboya"]
  spec.email         = ["mboyaberry@gmail.com"]

  spec.summary       = %q{connect to Mpesa API}
  spec.description   = %q{connect to Mpesa API to perform available transactions}
  spec.homepage      = "https://mboya.github.io/mpesa_connect/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.15.6'
  spec.add_dependency 'redis-rack', '~> 2.0', '>= 2.0.2'
  spec.add_dependency 'redis-namespace', '~> 1.5', '>= 1.5.3'
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'pry', '~> 0.10.4'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
end
