require 'digest/md5'

class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:index, :login_page, :login]

  def index
  end

  def login_page
    render 'login'
  end

  def login
    login = params[:login]
    model = nil
    if login[:user_type].to_sym == :follower
      model = Follower
    elsif login[:user_type].to_sym == :trader
      model = Trader
    else
      render status: :bad_request
    end
    user = model.verify login[:username], Digest::MD5.hexdigest(login[:password]), model
    if user
      session[:user_info] = {:user_id => user.id, :user_type => model}
      redirect_to_user_page user
    else
      flash[:error] = "Invalid username or password!"
      redirect_to login_path
    end
  end

  def logout
    session.clear
    redirect_to root_path
  end

  private

  def redirect_if_logged_in
    if session[:user_info]
      user = session[:user_info][:user_type].find(session[:user_info][:user_id])
      redirect_to_user_page user
    end
  end

  def redirect_to_user_page user
    path = user.class.to_s.downcase + "s_index_path"
    redirect_to self.send(path.to_sym, user)
  end
end
