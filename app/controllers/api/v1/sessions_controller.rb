module API
  module V1
    class SessionsController < ApplicationController
      def show
        render json: SessionSerializer.new(user: current_user).as_json
      end

      def create
        user = User.find_by email: params[:session][:email]
        if user && user.password == params[:session][:password]
          sign_in user
          render json: { user: current_user.slice(:id, :email) }, status: :created
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end

      end

      def destroy
        session.delete :user_id
        render json: {}
      end

      def current_user
        @current_user ||= User.find(current_user_id) if current_user_id
      end

      def sign_in user
        session[:user_id] = user.id
      end

      def current_user_id
        session[:user_id]
      end

      class SessionSerializer
        attr_reader :user
        attr_reader :auth_token

        def self.with_user user
          new(user: user)
        end

        def self.with_credentials email, password
        end

        def initialize options={}
          @user = options[:user]
          @auth_token = SecureRandom.hex
        end

        def as_json
          {
            user: user ? UserSerializer.new(user).as_json : nil,
            auth_token: auth_token
          }
        end
      end

      class UserSerializer
        attr_reader :user

        def initialize user
          @user = user
        end

        def as_json
          {
            id: user.id,
            email: user.email,
          }
        end
      end
    end
  end
end
