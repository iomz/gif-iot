# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gif-iot/version'

Gem::Specification.new do |spec|
  spec.name          = "gif-iot"
  spec.version       = GIFIoT::VERSION
  spec.authors       = ["Iori Mizutani"]
  spec.email         = ["iori.mizutani@gmail.com"]
  spec.homepage      = "https://github.com/iomz/gif-iot"
  spec.summary       = %q{mqtt-feed visualizer and influxdb ingester}
  spec.description   = %q{dynamic visualization for mqtt feed data}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "foreman"

  spec.add_dependency "addressable"
  spec.add_dependency "faye-websocket"
  spec.add_dependency "haml"
  spec.add_dependency "influxdb"
  spec.add_dependency "ipaddress"
  spec.add_dependency "json"
  spec.add_dependency "mqtt"
  spec.add_dependency "puma"
  spec.add_dependency "sass"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-activerecord"
  spec.add_dependency "sqlite3"

  spec.required_ruby_version = ">= 2.0.0"
end
