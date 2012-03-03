$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "omniauth-password/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "omniauth-password"
  s.version     = OmniauthPassword::VERSION
  s.authors     = ["Nathan Amick"]
  s.email       = ["github@nathanamick.com"]
  s.homepage    = "https://github.com/namick/omniauth-password"
  s.summary     = "An OmniAuth strategy for use with ActiveModel's has_secure_password"
  s.description = "An OmniAuth strategy for use with ActiveModel's has_secure_password"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_runtime_dependency "omniauth", "~> 1.0"
  s.add_runtime_dependency "bcrypt-ruby", "~> 3.0"


  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
end
