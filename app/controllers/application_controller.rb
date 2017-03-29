class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  delegate :allow_action?, :allow_params?, to: :current_permission
  helper_method :allow_action?, :allow_params?
  before_action :authorize
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:current_password])
  end
  private
    def current_resource
	  nil
	end
	def current_permission
	  @current_permission = Permission.new(current_user)
	end
	def authorize
	  if current_permission.allow_action?(params[:action], params[:controller], current_resource)
		current_permission.permit_params! params
	  else
		redirect_back_or_home("Not authorized")
	  end
	end
end
