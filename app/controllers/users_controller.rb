class UsersController < ApplicationController
  before_action :antiflood!, only: [:update, :create, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    flash.now[:alert] = t('controllers.users.show.not_found')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # default user level: 1
  end

  def delete
  end

  def destroy
  end

  def not_activated

  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
