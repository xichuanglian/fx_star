class FollowersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
  end

  def signup_page
    render 'signup'
  end

  def signup
  end

  private

  def require_login
    @user = session[:user]
    if @user == nil || @user.class != Follower
      redirect_to root_path
    end
  end
end
