# -*- coding: utf-8 -*-
require 'controller_modules/create_user_module'

class TradersController < ApplicationController
  include ControllerModules::CreateUserModule
  before_action :require_login, only: [:index, :settings,
                                       :modify_password, :bind_account]
  layout "trader"

  def index
    my_id = session[:user_info][:user_id]

    # 页面左栏信息
    @number_follow_me = Followship.where(:trader_id => my_id).count

    who_am_i = Trader.find my_id
    if who_am_i.account
      my_account_info = who_am_i.account.account_status_records.first
      @my_follow_date = '需要计算'
      @my_profit_rate = '需要计算'
      # 页面上栏信息
      @my_gain = '需要计算'
      @my_equity = my_account_info.equity
      @my_profit = my_account_info.profit
    else
      @my_profit_rate = '暂无数据'
      @my_follow_date = '暂无数据'
      @my_gain = '暂无数据'
      @my_equity = '暂无数据'
      @my_profit = '暂无数据'
    end
  end

  def new
    @trader = flash[:new_trader]
    render :layout => 'application'
  end

  def create
    begin
      p = params.require(:trader)
      verify_user_name p[:user_name]
      verify_unique_user_name p[:user_name], Trader
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

  def ranking_list
    @traders = []
    Trader.each do |t|
      next unless t.account
      account_info = t.account.account_status_records.first
      @traders << {:user_name => t.user_name,
        :profit => account_info.profit}
    end
    @traders.sort! {|t1, t2| t2[:profit] <=> t1[:profit]}
  end

  def settings
    @my_id = session[:user_info][:user_id]
  end

  def modify_password
    unless Trader.verify(@user.user_name,
                           Digest::MD5.hexdigest(params[:password][:original]),
                           Trader)
      flash[:field_error] ||= Hash.new
      flash[:field_error][:original] = "原始密码错误！"
    else
      verify_password params[:password][:password], params[:password][:confirmation]
    end

    unless flash[:field_error]
      @user.password = Digest::MD5.hexdigest params[:password][:password]
      @user.save!
    end
    flash[:info] = "密码修改成功！"
    redirect_to traders_settings_page_path(@user)
  end

  def bind_account
    account = @user.account
    unless account
      account = Account.new
      @user.account = account
      @user.save!
    end
    account.account_number = params[:trade_account][:account]
    account.password = params[:trade_account][:password]
    account.save!
    redirect_to traders_settings_page_path(@user)
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
