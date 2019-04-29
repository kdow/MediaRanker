class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])

    unless @user
      head :not_found
      return
    end
  end

  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]

    user = User.find_by(username: username)
    unless user
      user = User.create(username: username)
    end

    session[:user_id] = user.id

    flash[:status] = :success
    flash[:message] = "Successfully logged in as user #{user.username}"

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil

    flash[:status] = :success
    flash[:message] = "Successfully logged out"

    redirect_to root_path
  end
end
