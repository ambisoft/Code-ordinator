class UsersController < ApplicationController
    before_action :authenticate!, except: [:not_activated, :activate, :set_activation]
    before_action :check_for_session!, only: [:not_activated , :activate, :set_activation]
    before_action :antiflood!, only: [:create, :destroy, :set_activation]

    def new
        @user = User.new
    end

    def create
        @user = User.new(invitation_params) # default user level: 1
        if @user.save
            flash.now[:success] = [t('controllers.users.create.success')]
        else
            flash.now[:warning] = [t('controllers.users.create.invalid'), t('controllers.users.create.invalid_info')]
            pass_variable 'user_create'
            render 'new'
        end
    end

    def delete
    end

    def destroy
    end

    def not_activated
    end

    def activate
        @user = User.find_by_activation_token(params[:token])
        unless @user
            flash.now[:warning] = [t('controllers.users.activate.not_found')]
            render 'invalid_activation_token'
        end
    end

    def set_activation
        @user = User.find_by_activation_token(params[:token])
        if @user
            if @user.update(activation_params)
                flash[:success] = [t('controllers.users.activate.success')]
                redirect_to new_sessions_path
            else
                flash.now[:warning] = [t('controllers.users.activate.invalid'), t('controllers.users.activate.invalid_info')]
                render 'activate'
            end
        else
            flash[:warning] = [t('controllers.users.activate.not_found')]
            render 'invalid_activation_token'
        end
    end

    private
    def invitation_params
        params.require(:user).permit(:email)
    end
    def activation_params
        data = params.require(:user).permit(:password, :password_confirmation)
        data[:activation_token] = nil
        data[:activation_status] = true
        data
    end
end
