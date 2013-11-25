class SessionsController < ApplicationController
  def index
    if session[:user]
      @user = session[:user]
      path = @user.class.to_s.downcase + "_index_path"
      redirect_to self.send(path.to_sym)
    end
  end

  def login_page
    render 'login'
  end

  def login

  end

  def logout
    session.clear
    redirect_to root_path
  end
end
