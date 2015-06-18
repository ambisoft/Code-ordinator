class PagesController < ApplicationController
    before_action :authenticate!

    def index
        @notes_count = Note.count
    end
end
