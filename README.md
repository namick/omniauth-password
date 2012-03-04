# OmniauthPassword

The OmniAuth Password gem is designed to be a simple way to add local login/password authentication along side other strategies.  It simply makes ActiveModel's `has_secure_password` work directly with OmniAuth like any other provider without the need for a separate Authentication or Identity model.

This gem will work well for you if you want to create your authentication system from scratch.  Authenticating to a local User model is treated just like authenticating to an external provider like Twitter. OmniAuth Password stays out of your way leaving local user registration up to you.  It does not provide controllers or views.

## Installation

Add the strategy to your Gemfile

    gem 'omniauth-password'

Add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      # provider :twitter ...
      # provider :github ...
      provider :password
    end

Add some routes:

      match "/auth/:provider/callback" => "sessions#create"
      match "/auth/failure", to: "sessions#failure"
      resource :session

OmniAuth Password expects a POST to `/auth/password/callback` with login params in the session hash.  You might create a form something like this:

    <h1>Sign in</h1>

    <%= form_for(:sessions, url: "/auth/password/callback") do |f| %>
      <div class="field">
        <%= label_tag :email %><br />
        <%= f.text_field :email %>
      </div>
      <div class="field">
        <%= label_tag :password %><br />
        <%= f.password_field :password %>
      </div>
      <div class="actions">
        <%= submit_tag "Sign in" %>
      </div>
    <% end %>

Your Sessions controller's `create` method takes the omniauth hash from this and any other strategy you are using; it might look something like this:

    class SessionsController < ApplicationController
      def new
      end

      def create
        user = User.from_omniauth(request.env["omniauth.auth"])
        session[:user_id] = user.id
        redirect_to root_url, notice: "Signed in"
      end

      def destroy
        session[:user_id] = nil
        redirect_to root_url, notice: "Signed out"
      end

      def failure
        redirect_to new_session_path, notice: "Authentication failed"
      end
    end

The User model does not need a `uid` field for OmniAuth because it reuses the password_digest field when not doing local login/password authentication.  ActiveModel's `has_secure_password` causes password_digest to be a required field.:

    # == Schema Information
    #
    # Table name: users
    #
    #  id              :integer         not null, primary key
    #  email           :string(255)
    #  provider        :string(255)
    #  password_digest :string(255)
    #

    class User < ActiveRecord::Base
      has_secure_password

      def self.from_omniauth(auth)
        find_by_provider_and_password_digest(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
      end

      def self.create_with_omniauth(auth)
        create! do |user|
          user.provider = auth["provider"]
          user.password_digest = auth["uid"]
          user.name = auth["info"]["name"]
        end
      end
    end

## Customizing

By default, OmniAuth Password expects to authenticate to the email and password of the User model.  You can override these in your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      # provider :twitter ...
      # provider :github ...
      provider :password, :login_field => :username, :user_model => Admin
    end

