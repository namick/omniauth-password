# OmniauthPassword

The OmniAuth Password gem is designed to be the easiest way to add local user/password authentication along side other strategies.  It simply makes ActiveModel's `has_secure_password` work directly with OmniAuth like any other provider.

Authenticating to a local User model is treated just like authenticating to an external provider like Twitter.  

## Installation

Add the strategy to your Gemfile

    gem 'omniauth-password'

Add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :password
    end


