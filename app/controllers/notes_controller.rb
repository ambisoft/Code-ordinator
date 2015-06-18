class NotesController < ApplicationController
    before_action :authenticate!

    def index
        @user = User.find_by_id!(session[:user]['id'])
        @notes = @user.notes.order(updated_at: :desc)
    end

    def show
        @note = Note.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.show.not_found')]
            redirect_to notes_path
        end
    end

    def edit
        @note = Note.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.edit.not_found')]
            redirect_to notes_path
        end
    end

    def update
        @note = Note.find_by_id(params[:id])
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
        @note = Note.find_by_id!(params[:id])
        if @note
            @note.destroy
            flash[:success] = [t('controllers.notes.delete.success')]
        else
            flash[:warning] = [t('controllers.notes.delete.not_found')]
        end
        redirect_to notes_path
    end

    def delete
        @note = Note.find_by_id(params[:id])
        unless @note
            flash[:warning] = [t('controllers.notes.delete.not_found')]
            redirect_to notes_path
        end
    end

    def new
        @note = Note.new
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
