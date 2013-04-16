# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "admin-cf-plugin/version"

Gem::Specification.new do |s|
  s.name        = "admin-cf-plugin"
  s.version     = CFAdmin::VERSION.dup
  s.authors     = ["Alex Suraci"]
  s.email       = ["asuraci@vmware.com"]
  s.homepage    = "http://cloudfoundry.com/"
  s.summary     = %q{
    Cloud Foundry administration commands.
  }

  s.rubyforge_project = "admin-cf-plugin"

  s.add_runtime_dependency "cfoundry", ">= 0.7.0.rc3", "< 0.8"

  s.files         = %w{Rakefile} + Dir.glob("lib/**/*")
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
