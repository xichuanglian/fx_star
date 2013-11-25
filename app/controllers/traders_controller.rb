require 'ruby-debug'
require 'digest/md5'

class TradersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
  end

  def new
    @trader = flash[:new_trader]
  end

  def create
    begin
      p = params.require(:trader)
      verify_user_name p[:user_name]
      verify_unique_user_name p[:user_name]
      verify_password p[:password], p[:password_confirmation]
      verify_email p.require(:email)
      if flash[:field_error]
        flash[:new_trader] = Trader.new permit_params(p.except(:password, :password_confirmation))
        redirect_to traders_new_path
      else
        @trader = Trader.create!(permit_params hide_password(p.except(:password_confimation)))
        if @trader
          session[:user] = @trader
          redirect_to traders_index_path(@trader)
        else
          flash[:error] = "Database error. Can't create new trader."
          redirect_to traders_new_path
        end
      end
    rescue ActionController::ParameterMissing
      flash[:error] = "You have to fill required fields!"
      redirect_to traders_new_path
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
    h.permit(:user_name, :password, :email)
  end

  def hide_password h
    h[:password] = Digest::MD5.hexdigest h[:password]
    #h[:password_confirmation] = Digest::MD5.hexdigest h[:password_confirmation]
    return h
  end

  def verify_user_name user_name
    unless Trader.user_name_format.match user_name
      flash[:field_error] ||= Hash.new
      flash[:field_error][:user_name] = "Invalid user name!"
    end
  end

  def verify_unique_user_name user_name
    unless not Trader.where(name: user_name).exists?
      flash[:field_error] ||= Hash.new
      flash[:field_error][:user_name] = "User name occupied!"
    end
  end

  def verify_password password, password_confirmation
    unless password == password_confirmation
      flash[:field_error] ||= Hash.new
      flash[:field_error][:password] = "Passwords do not match!"
    end
  end

  def verify_email email
    unless Trader.email_format.match email
      flash[:field_error] ||= Hash.new
      flash[:field_error][:email] = "Invalid email!"
    end
  end

end
