#require 'omniauth'
#require 'omniauth-password'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :password
end
