module API
  module V1
    class SessionsController < ApplicationController
      def show
        render json: { user: current_user }
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
    end
  end
end
