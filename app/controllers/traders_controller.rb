require 'ruby-debug'
require 'digest/md5'

class TradersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
  end

  def new
  end

  def create
    begin
      p = params.require(:trader).hide_password!
      unless valid_user_name p.require(:user_name)
      end
      unless valid_password p.require(:password), p.require(:password_confirmation)
      end
      unless valid_email p.require(:email)
      end
      @trader = Trader.create!(permit_params hide_password)
    rescue ActionController::ParameterMissing
      render status: :bad_request
    end
  end

  private

  def require_login
    @user = session[:user]
    if @user == nil || @user.class != Trader
      redirect_to root_path
    end
  end

  def permit_params h
    h.permit(:user_name, :password, :password_confirmation, :email)
  end

  def hide_password! h
    h[:password] = Digest::MD5.hexdigest h.require(:password)
    h[:password_confirmation] = Digest::MD5.hexdigest h.require(:password_confirmation)
  end

  def valid_user_name user_name
    true
  end

  def valid_password password, password_confirmation
    true
  end

  def valid_email email
    true
  end

end
