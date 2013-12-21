class FollowshipsController < ApplicationController
  #before_action :require_login, only: [:index]

  def create
    follower_id = params[:id]
    trader_id = params[:trader_id]

    Followship.create(:follower_id => follower_id, :trader_id => trader_id, :since => DateTime.current, :percentage => 100)


    redirect_to followers_index_path
  end


end
