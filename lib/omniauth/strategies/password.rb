module OmniAuth
  module Strategies
    class Password
      include OmniAuth::Strategy

      option :model, nil # default set to 'User' below
      option :login_field, :email

      def request_phase
        redirect "/sessions/new"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless user.try(:authenticate, password)
        super
      end

      def user
        @user ||= model.send("find_by_#{options[:login_field]}", login)
      end

      def model
        options[:model] || ::User
      end

      def login
        request[:sessions][options[:login_field].to_s]
      end

      def password
        request[:sessions]['password']
      end

      uid do
        user.password_digest
      end

    end
  end
end
