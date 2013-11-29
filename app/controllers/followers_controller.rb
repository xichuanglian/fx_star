class FollowersController < ApplicationController
  include ControllerModules::CreateUserModule
  before_action :require_login, only: [:index]

  def index
  end

  def new
    @follower = flash[:new_follower]
  end

  def create
    begin
      p = params.require(:follower)
      verify_user_name p[:user_name]
      verify_unique_user_name p[:user_name]
      verify_password p[:password], p[:password_confirmation]
      verify_email p.require(:email)
      if flash[:field_error]
        flash[:new_follower] = Follower.new permit_params(p.except(:password, :password_confirmation))
        redirect_to followers_new_path
      else
        @follower = Follower.create!(permit_params hide_password(p.except(:password_confimation)))
        if @follower
          session[:user] = @follower
          redirect_to followers_index_path(@follower)
        else
          flash[:error] = "Database error. Can't create new follower."
          redirect_to followers_new_path
        end
      end
    rescue ActionController::ParameterMissing
      flash[:error] = "You have to fill required fields!"
      redirect_to followers_new_path
    end
  end

  private

  def require_login
    @user = session[:user]
    if @user == nil || @user.class != Follower
      redirect_to root_path
    end
  end

  def permit_params h
    h.permit(:user_name, :password, :email)
  end
end
