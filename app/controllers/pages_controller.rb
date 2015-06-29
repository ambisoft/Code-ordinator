class PagesController < ApplicationController
    before_action :authenticate!

    def index
        @user = User.find_by_id!(session[:user]['id'])
        @notes_count = @user.notes.count
    end
end
