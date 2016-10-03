class RecipesController < ApplicationController
  before_action :find_recipe, only: [:show, :edit, :update, :destroy]
  before_action :store_location, only: [:show, :index]
  def index
	@recipes = Recipe.all
  end

  def show
	@vote = Vote.new
	@best_recipes = Recipe.cached_best_recipes
  end

  def new
	@recipe = Recipe.new
  end

  def create
	@recipe = Recipe.new(recipe_params)
	@recipe.user_id = current_user.id
	if @recipe.save
	  flash[:success] = "You have created new recipe!"
	  redirect_to @recipe
	else
	  render 'new'
	end
  end

  def edit
  end

  def update
	if @recipe.update_attributes(recipe_params)
	  flash[:success] = "You have updated new recipe!"
	  redirect_to @recipe
	else
	  render 'edit'
	end
  end
  
  def destroy
	@recipe.destroy
	flash[:success] = "Your recipe has been deleted!"
	redirect_to root_path
  end
  
  private
	def current_resource
	  #@current_resource = Recipe.find_by(id: params[:id])
	  @current_resource = Recipe.cached_find_by(params[:id])
	end
	def find_recipe
	  @recipe = @current_resource
	  redirect_back_or_home("Not found") unless @recipe # xem co confict with authrize neu khac path
	end
	def recipe_params
	  #params.require(:recipe).permit(:title, :description, :image, ingredients_attributes: [:name, :id, :_destroy], directions_attributes: [:name, :id, :_destroy])
	  params.require(:recipe).permit!
	end
end