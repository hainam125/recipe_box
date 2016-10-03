class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe, touch: true
  
  validates :value, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :recipe_id }
  
  def cached_user
	User.cached_find_by(user_id)
  end
end