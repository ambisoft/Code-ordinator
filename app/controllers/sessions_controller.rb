class SessionsController < ApplicationController
    before_action :check_for_session!, except: [:destroy]
    before_action :antiflood!, only: [:create]

    def new
        @session = Session.new
    end

    def create data = nil
        @session = Session.new(data ? data : session_params)
        if @session.valid?
            user = User.find_by_id!(@session.id)

            if !user.activation_status && !data
                redirect_to '/user/not_activated'
                return
            end

            session[:user] = Hash.new
            session[:user][:id] = user.id
            session[:user][:email] = user.email
            session[:user][:level] = user.level

            flash[:success] = [t('controllers.sessions.create.success')]
            redirect_to root_path
        else
            flash.now[:warning] = [t('controllers.sessions.create.invalid'), t('controllers.sessions.create.invalid_info')]
            pass_variable 'session_create'
            render 'new'
        end
    end

    def destroy
        session[:user] = nil
    end

    private
    def session_params
        params.require(:session).permit(:email, :password)
    end
    def check_for_session!
        if session[:user]
            redirect_to root_path
            false
        else
            true
        end
    end
end
