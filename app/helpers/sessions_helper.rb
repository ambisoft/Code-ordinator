module SessionsHelper

    def sign_in(user)
        session[:user] = Hash.new
        session[:user][:id] = user.id
        session[:user][:email] = user.email
        session[:user][:level] = user.level
    end

end
