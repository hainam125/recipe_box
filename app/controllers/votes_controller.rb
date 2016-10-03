class VotesController < ApplicationController
  before_action :find_recipe, only: [:create,:edit, :update, :destroy]
  before_action :find_vote, only: [:update,:edit, :update, :destroy]
  
  def create
	@vote = @recipe.votes.build(votes_params)
	@vote.user = current_user
	respond_to do |format|
	  if @vote.save
		format.js
	  else
		flash[:warning] = "Something wrong!"
	  end
	  format.html {redirect_to @recipe }
	end
  end
  
  def edit
  
  end
  def update
	respond_to do |format|
	  if @vote.update_attributes(votes_params)
		format.js
	  else
		flash[:warning] = "Something wrong!"
	  end
	  format.html {redirect_to @recipe }
	end
  end
  
  def destroy
	@vote.destroy
	respond_to do |format|
	  format.html {redirect_to @recipe}
	end
  end
  
  private
	def votes_params
	  params.require(:vote).permit(:value, :content)
	end
	def find_recipe
	  @recipe = Recipe.find_by(id: params[:recipe_id])
	  redirect_to root_path unless @recipe
	end
	def find_vote
	  @vote = @current_resource
	  redirect_to root_path unless @vote
	end
	def current_resource
	  @current_resource = Vote.find_by(id: params[:id])
	end
end
