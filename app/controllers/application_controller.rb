class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    helper_method :antiflood!, :authenticate!, :is_signed?, :pass_variable, :check_for_session!

    def antiflood! (now = false)
        antiflood = 5 # in seconds
        time = Time.new.to_i

        if session[:antiflood].nil?
            session[:antiflood] = time
            true
        else
            if session[:antiflood] + antiflood < time
                session[:antiflood] = time
                true
            else
                warning = t('controllers.antiflood', time: (session[:antiflood]-time+antiflood).to_s)
                now ? flash.now[:warning] = [warning, t('controllers.antiflood_info')] : flash[:warning] = [warning, t('controllers.antiflood_info')]
                redirect_to :back
            end
        end
    end

    def authenticate!
        if session[:user]
            true
        else
            flash[:warning] = [t('controllers.authenticate'), t('controllers.authenticate_info')]
            redirect_to new_sessions_path
        end
    end

    def is_signed?
        session[:user] ? true : false
    end

    def pass_variable (variable = nil)
        if variable
            @variable = variable
        else
            @variable
        end
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
