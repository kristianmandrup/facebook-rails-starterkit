# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "facebook-rails-starterkit"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristian Mandrup"]
  s.date = "2012-05-07"
  s.description = "Make it simple to get started using Facebook with Rails!"
  s.email = "kmandrup@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "config/locales/omniauth/en.yml",
    "facebook-rails-starterkit.gemspec",
    "lib/facebook-rails-starterkit.rb",
    "lib/facebook/access/helper.rb",
    "lib/facebook/access/omniauth.rb",
    "lib/facebook/app.rb",
    "lib/facebook/auth/devise.rb",
    "lib/facebook/graph_api.rb",
    "spec/facebook-rails-starterkit/config_loader/yaml_spec.rb",
    "spec/facebook-rails-starterkit_spec.rb",
    "spec/fixtures/config/facebook.yml",
    "spec/fixtures/config/htc.yml",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/kristianmandrup/facebook-rails-starterkit"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Starterkit for using Facebook with Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<koala>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<hashie>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<rails_config_loader>, ["~> 0.1.1"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.1.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0.5"])
    else
      s.add_dependency(%q<koala>, [">= 1.4.0"])
      s.add_dependency(%q<hashie>, ["~> 1.2.0"])
      s.add_dependency(%q<rails_config_loader>, ["~> 0.1.1"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.1.0"])
      s.add_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0.5"])
    end
  else
    s.add_dependency(%q<koala>, [">= 1.4.0"])
    s.add_dependency(%q<hashie>, ["~> 1.2.0"])
    s.add_dependency(%q<rails_config_loader>, ["~> 0.1.1"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.1.0"])
    s.add_dependency(%q<jeweler>, [">= 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0.5"])
  end
end

