# -*- coding: utf-8 -*-
require 'controller_modules/create_user_module'

class TradersController < ApplicationController
  include ControllerModules::CreateUserModule
  before_action :require_login, only: [:index]
  layout "trader"

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
          session[:user_info] = {:user_id => @trader.id, :user_type => Trader}
          redirect_to traders_index_path(@trader)
        else
          flash[:error] = "数据库错误，无法创建账户！"
          redirect_to traders_new_path
        end
      end
    rescue ActionController::ParameterMissing
      flash[:error] = "注册信息必须填写完整！"
      redirect_to traders_new_path
    end
  end

  def show_for_follower
    @trader = Trader.find(params[:trader_id])
  end

  private

  def require_login
    if session[:user_info] == nil or session[:user_info][:user_id] == nil
      redirect_to root_path
      return
    end
    @user = Trader.find(session[:user_info][:user_id])
    if @user == nil || @user.class != Trader
      redirect_to root_path
    end
  end

  def permit_params h
    h.permit(:user_name, :password, :email)
  end
end
