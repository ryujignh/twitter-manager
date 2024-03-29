class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    session[:token] = auth_hash["credentials"]["token"]
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    session[:token] = nil
    @user = nil
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
