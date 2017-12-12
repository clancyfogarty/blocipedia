class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.private?
      params[:wiki][:collaborator_ids].each do |c|
        if c == ''
          @wiki.collaborators.clear
        else
          collaborator = User.find(c)
          @wiki.collaborators << Collaborator.new(user_id: collaborator.id, wiki_id: params[:id])
        end
      end
    end

    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki, please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    if @wiki.private?
      params[:wiki][:collaborator_ids].each do |c|
        if c == ''
          @wiki.collaborators.clear
        else
          collaborator = User.find(c)
          @wiki.collaborators << Collaborator.new(user_id: collaborator.id, wiki_id: params[:id])
        end
      end
    end

    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error updating the wiki, please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_url
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
