module ApplicationHelper
  def remove_field(name=nil)
	link_to((name || "Remove"), "#", class: "remove_field btn btn-default")
  end
  def add_field(name, f, association)
	new_object = f.object.send(association).new #.klass??
	id = new_object.object_id
	fields = f.fields_for(association, new_object, child_index: id) do |builder|
	  render association.to_s.singularize + "_fields" , f: builder
	end
	link_to(name, "#", data: {id: id, fields: fields.gsub("\n","")}, class: "add_field btn btn-default")
  end
  def store_location
	session[:redirect_back] = request.original_url
  end
  def redirect_back_or_home(msg=nil)
	flash[:warning] = msg if msg
	redirect_to(session[:redirect_back] || root_path)
	session.delete(:redirect_back)
  end
  def current_user?(user)
	current_user == user
  end
  def voting_form_for(recipe, vote=nil)
	value = vote ? vote.value : 0
	form_id = "recipe_#{recipe.id}"
	content_tag(:div, id: "rating") do
	  content_tag("ul") do
		(1..5).each do |n|
		  css_id = "#{form_id}_star_#{n}"
		  data_value = n
		  css_class= n > value ? "rating_star" : css_class="rating_star on"
		  yield(css_id, css_class, data_value,form_id)
		end
	  end
	end
  end
  def current_star_for(star)
	content_tag("ul") do
		(1..5).each do |n|
		  if n <= star
		    css_class = "current_star on"
		  elsif n < star + 1
			css_class = "current_star half"
		  else
		    css_class = "current_star"
		  end
		  yield(css_class)
		end
	end
  end
end
