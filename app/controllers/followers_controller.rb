# -*- coding: utf-8 -*-
#require 'ruby-debug'
require 'controller_modules/create_user_module'

class FollowersController < ApplicationController
  include ControllerModules::CreateUserModule
  before_action :require_login, only: [:index]
  layout 'follower'

  def index
    # 推荐高手
    @all_traders = []
    Trader.each do |t|
      next unless t.account
      account_info = t.account.account_status_records.first
      @all_traders << {:user_name => t.user_name,
                       :equity => account_info.equity,
                       :profit => account_info.profit}
    end
    @all_traders.sort!{|t1, t2| t2[:profit] <=> t1[:profit]}

    # 页面左栏信息
    who_am_i = Follower.find session[:user_info][:user_id]
    my_account_info = who_am_i.account.account_status_records.first
    @my_follow_date = '需要计算'
    @my_profit_rate = '需要计算'

    # 页面上栏信息
    @my_equity = my_account_info.equity
    @my_profit = my_account_info.profit



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
      # verify_something will set flash[:field_error] if something is not valid
      if flash[:field_error]
        flash[:new_follower] = Follower.new permit_params(p.except(:password, :password_confirmation))
        redirect_to followers_new_path
      else
        @follower = Follower.create!(permit_params hide_password(p.except(:password_confimation)))
        if @follower
          session[:user_info] = {:user_id => @follower.id, :user_type => Follower}
          redirect_to followers_index_path(@follower)
        else
          flash[:error] = "数据库错误，无法创建新账户！"
          redirect_to followers_new_path
        end
      end
    rescue ActionController::ParameterMissing
      flash[:error] = "注册信息必须填写完整！"
      redirect_to followers_new_path
    end
  end

  def ranking_list


  end

  private

  def require_login
    if session[:user_info] == nil or session[:user_info][:user_id] == nil
      redirect_to root_path
      return
    end
    @user = Follower.find(session[:user_info][:user_id])
    if @user == nil || @user.class != Follower
      redirect_to root_path
    end
  end

  def permit_params h
    h.permit(:user_name, :password, :email)
  end
end
