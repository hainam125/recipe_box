class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable # :confirmable, :lockable, :timeoutable and :omniauthable
  
  
  has_many :creating_recipes, class_name: "Recipe", foreign_key: :user_id
  has_many :votes, dependent: :destroy
  has_many :voting_recipes, through: :votes, source: :recipe
  
  def vote_this?(recipe)
	voting_recipes.include?(recipe)
  end
  
  after_commit :flush_cache
  
  def self.cached_find_by(id)
	Rails.cache.fetch([name, id]) { find_by(id: id) }
  end
  def flush_cache
	Rails.cache.delete([self.class.name, id])
  end
end
