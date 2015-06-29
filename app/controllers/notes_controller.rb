class NotesController < ApplicationController
    before_action :authenticate!
    before_action :antiflood!, only: [:update, :create, :destroy]

    def index
        @user = User.find_by_id!(session[:user]['id'])
        @notes = @user.notes.order(updated_at: :desc)
    end

    def show
        @user = User.find_by_id!(session[:user]['id'])
        @note = @user.notes.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.show.not_found')]
            redirect_to notes_path
        end
    end

    def edit
        @user = User.find_by_id!(session[:user]['id'])
        @note = @user.notes.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.edit.not_found')]
            redirect_to notes_path
        end
    end

    def update
        @user = User.find_by_id!(session[:user]['id'])
        @note = @user.notes.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.update.not_found')]
            redirect_to notes_path
        end

        if @note.update(note_params)
            flash[:success] = [t('controllers.notes.update.success')]
            redirect_to @note
        else
            flash.now[:warning] = [t('controllers.notes.update.invalid'), t('controllers.notes.update.invalid_info')]
            render 'edit'
        end

    end

    def destroy
        @user = User.find_by_id!(session[:user]['id'])
        succeed_notes = []
        failed_notes = []

        id = JSON.parse(params[:id])

        id.each do |t|
            note = @user.notes.find_by_id(t)
            if note
                note.destroy
                succeed_notes << t
            else
                failed_notes << t
            end
        end

        flash[:success] = [t('controllers.notes.destroy.success'), t('controllers.notes.destroy.success_info', id: succeed_notes.join(', '))] if succeed_notes.any?
        flash[:warning] = [t('controllers.notes.destroy.not_found'), t('controllers.notes.destroy.not_found_info', id: failed_notes.join(', '))] if failed_notes.any?

        redirect_to notes_path
    end

    def delete
        @user = User.find_by_id!(session[:user]['id'])
        @found_notes = []
        @not_found_notes = []

        # Prepare variable
        id = params[:id]
        if /^[0-9]+$/.match(id)
            id = [id]
        else
            id = JSON.parse(id)
        end

        # Sort ids by found/not found notes
        id.each do |t|
            (@user.notes.exists?(id: t) ? @found_notes : @not_found_notes) << t
        end

        # Check whether there was one id or more
        if id.length > 1
            # Check if none of notes have been found or only some of them
            if @found_notes.empty?
                flash[:warning] = [t('controllers.notes.delete.none_of_notes_found')]
                redirect_to notes_path
                return
            elsif @not_found_notes.any?
                flash.now[:warning] = [t('controllers.notes.delete.some_of_notes_not_found'),
                                       t('controllers.notes.delete.some_of_notes_not_found_info', id: @not_found_notes.join(', '))]
            end
        else
            # Check if ONE note has been found
            if @not_found_notes.any?
                flash[:warning] = [t('controllers.notes.delete.not_found')]
                redirect_to notes_path
            end
        end
    end

    def new
        @user = User.find_by_id!(session[:user]['id'])
        @note = @user.notes.new
        pass_variable 'note_create'
    end

    def create
        @user = User.find_by_id!(session[:user]['id'])
        @note = @user.notes.new(note_params)

        if @note.save
            flash[:success] = [t('controllers.notes.create.success')]
            redirect_to @note
        else
            flash.now[:warning] = [t('controllers.notes.create.invalid'), t('controllers.notes.create.invalid_info')]
            pass_variable 'note_create'
            render 'new'
        end
    end

    private
    def note_params
        params.require(:note).permit(:title, :content)
    end
end
