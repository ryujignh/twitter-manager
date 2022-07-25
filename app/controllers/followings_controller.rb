class FollowingsController < ApplicationController

  before_action :set_twitter_client

  def index

    if current_user.nil?
      redirect_to root_path
    else
      # Initializing via options

      begin
        response = get_followings(params[:pagination_token])
        @previous_token = response[:meta][:previous_token]
        @next_token = response[:meta][:next_token]
        @followings = response[:data]
      rescue => e
        @error = e
      end
    end
  end

  def get_followings(pagination_token)
    Rails.cache.fetch("followings#{pagination_token}", expires_in: 1.hour) do
      if pagination_token.present?
        puts "***************************I'm calling API***************************"
        @client.get("https://api.twitter.com/2/users/#{current_user.uid}/following", pagination_token: pagination_token)
      else
        puts "***************************I'm calling API***************************"
        @client.get("https://api.twitter.com/2/users/#{current_user.uid}/following")
      end
    end
  end

  def destroy_multiple
    ids = params[:ids]
    begin
      ids.each do |id|
        @client.delete("https://api.twitter.com/2/users/#{current_user.uid}/following/#{id.to_i}")
      end
    rescue => e
      @error = e
    end

    if @error.nil?
      Rails.cache.delete("followings")
      redirect_to followings_path
      flash[:notice] = "Unfollowed Successfully"
    else
      redirect_to followings_path
      flash[:notice] = "Error"
    end
  end

  private

  def set_twitter_client
    user_id = session[:user_id]
    if user_id.nil?
      redirect_to root_path
    else
      @client = SimpleTwitter::Client.new(bearer_token: session[:token])
    end
  end

  def following_params
    params.require(:following).permit(:ids)
  end
end
