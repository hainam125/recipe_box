class Permission
  def initialize(user)
	allow_action [:destroy, :new, :create], "devise/sessions"
	allow_action [:destroy, :new, :create, :cancel], "devise/registrations"
	allow_action [:new, :create, :edit, :update], "devise/passwords"
	allow_action [:index, :show], [:recipes, :users]
	if user
	  allow_action [:edit, :update], :users do |this_user|
		this_user == user
	  end
	  allow_action [:edit, :update], "devise/registrations"
	  allow_action [:new, :create],[:recipes, :votes]
	  allow_action [:edit, :update],:recipes do |recipe|
		recipe.user_id == user.id
	  end
	  allow_action [:edit, :update, :destroy], :votes do |vote|
		vote.user_id == user.id
	  end
	  allow_params :user, [:email, :password, :password_confirmation, :current_password]
	  allow_params :recipe, [:title, :description, :image, ingredients_attributes: [:name, :id, :_destroy], directions_attributes: [:name, :id, :_destroy]]
	  #add other user(devise) resource??
	  allow_all if user.admin?
	end
  end
  
  def allow_all
	@allow_all ||= true
  end
  
  def allow_action?(action, controller, resource=nil)
	allowed = @allow_all || @allowed_action[[action.to_s, controller.to_s]]
	allowed && (allowed == true || resource && allowed.call(resource))
  end
  
  def allow_action(actions, controllers, &block)
	@allowed_action ||= {}
	Array(controllers).each do |controller|
	  Array(actions).each do |action|
		@allowed_action[[action.to_s, controller.to_s]] = block || true
	  end
	end
  end
  
  def allow_params?(resource, attribute)
	if @allow_all
	  true
	elsif @allowed_params && @allowed_params[resource.to_s]
	  @allowed_params[resource.to_s].include?(attribute.to_s)
	end
  end
  
  def allow_params(resources, attributes)
	@allowed_params ||= {}
	Array(resources).each do |resource|
	  @allowed_params[resource.to_s] ||= []
	  @allowed_params[resource.to_s] += Array(attributes).map(&:to_s)
	end
  end
  
  def permit_params!(params)
    if @allow_all
	  params.permit!
	elsif @allowed_params
	  @allowed_params.each do |resource, attributes|
		if params[resource].respond_to? :permit
		  params[resource] = params[resource].permit(*attributes)
		end
	  end
	end
  end
end