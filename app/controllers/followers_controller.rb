# -*- coding: utf-8 -*-
#require 'ruby-debug'
require 'controller_modules/create_user_module'
#require 'carrierwave/processing/rmagick'

class FollowersController < ApplicationController
  include ControllerModules::CreateUserModule
  before_action :require_login, only: [:index, :best_traders, :settings,
                                       :modify_password, :bind_account,
                                       :history, :followship, :register_trade_account,
                                       :create_trade_account]
  layout 'follower'

  def index
    @my_id = session[:user_info][:user_id]

    # 是否已跟单
    if Followship.where(:follower_id => @my_id).exists?
      @followship = Followship.where(:follower_id => @my_id).first
      trader_id = @followship.trader_id
      @trader = Trader.find(trader_id)
    end


    # 推荐高手
    @best_traders = Trader.best_traders

    # 页面左栏信息
    who_am_i = Follower.find @my_id
    if who_am_i.account && who_am_i.account.account_status_records
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
    @follower = flash[:new_follower]
    render :layout => 'application'
  end

  def create
    begin
      p = params.require(:follower)
      verify_user_name p[:user_name]
      verify_unique_user_name p[:user_name], Follower
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

  def best_traders
    @best_traders = Trader.best_traders
  end

  def settings
    @my_id = session[:user_info][:user_id]
  end

  def modify_password
    unless Follower.verify(@user.user_name,
                           Digest::MD5.hexdigest(params[:password][:original]),
                           Follower)
      flash[:field_error] ||= Hash.new
      flash[:field_error][:original] = "原始密码错误！"
    else
      verify_password params[:password][:password], params[:password][:confirmation]
    end

    unless flash[:field_error]
      @user.password = Digest::MD5.hexdigest params[:password][:password]
      @user.save!
    end
    redirect_to followers_settings_page_path(@user)
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
    redirect_to followers_settings_page_path(@user)
  end

  def history
    unless @user.account
      flash[:error] = "您尚未绑定券商账户！"
      @records = []
    else
      @records = @user.account.trade_records
    end
  end

  def followship
    @followships = []
    @user.followships.each do |f|
      @followships << {
        :trader => f.trader.user_name,
        :percentage => f.percentage,
        :since => f.since
      }
    end
  end

  def register_trade_account

  end

  def create_trade_account
    if params[:password][:password] != params[:password][:confirmation]
      flash[:field_error] = '两次输入的密码不一致！'
      redirect_to followers_register_trade_account_page_path
      return
    end

    # text information
    @user.trade_account_name = params[:name][:name]
    @user.trade_account_identity_number = params[:identity_number][:identity_number]
    @user.trade_account_email = params[:email][:email]
    @user.trade_account_password = params[:password][:password]

    # id card photo
    if params[:post_image]
      uploaded_image = params[:post_image][:image]
      @user.idcard = uploaded_image
    end

    @user.save!
    flash[:info] = '账户信息提交成功'
    redirect_to followers_register_trade_account_page_path
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
