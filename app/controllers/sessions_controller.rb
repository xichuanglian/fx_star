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
end
