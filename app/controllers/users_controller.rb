class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :store_location, only: [:show, :index]
  def index
    @users = User.all
  end

  def show
	respond_to do |format|
	  format.html
	  format.js
	end
  end

  def new
	@user = User.new
  end
  # def create
	# @user = User.new(user_params)
	# if @user.save
	  # flash[:success] = "Thank you for sign up!"
	  # redirect_to @user
	# else
	  # render 'new'
	# end
  # end

  def edit
  end
  def update
	if @user.update_attributes(user_params)
	  flash[:success] = "This account have been updated!"
	  redirect_to @user
	else
	  render 'edit'
	end
  end
  def destroy
	@user.destroy
	flash[:success] = "This account have been destroyed!"
	redirect_to users_path
  end
  private
	def find_user
	  @user = @current_resource
	  redirect_back_or_home("Not found") unless @current_resource
	end
	def current_resource
	  @current_resource = User.find_by(id: params[:id])
	end
	def user_params
	  params.require(:user).permit!
	end
end
