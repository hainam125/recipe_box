class Recipe < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user
  belongs_to :creating_users, class_name: "User", foreign_key: :user_id
  has_many :ingredients, dependent: :destroy
  has_many :directions, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: proc { |a| a["name"].blank? }, allow_destroy: true
  accepts_nested_attributes_for :directions, reject_if: proc { |a| a["name"].blank? }, allow_destroy: true
  
  mount_uploader :image, ImageUploader
  validates :title, presence: true
  validates :description, presence: true
  
  after_commit :flush_cache
  
  def vote_from(user)
	if user && user.vote_this?(self)
	  @vote = votes.find_by(user_id: user.id)
	else
	  @vote = Vote.new
	end
  end
  
  def flush_cache
	Rails.cache.delete([self.class.name, id])
	Rails.cache.delete([self.class.name, "best_recipes"])
  end
  
  def self.best_recipes
	all.sort{ |a,b| b.cahed_avarage_vote <=> a.cahed_avarage_vote }[0..3]
  end
  def self.cached_best_recipes
	Rails.cache.fetch([name, "best_recipes"]) do
	  all.sort{ |a,b| b.cahed_avarage_vote <=> a.cahed_avarage_vote }[0..3]
	end
  end
  
  def avarage_vote
	#self.votes.any? ? (self.votes.average(:value)*2).round / 2.0 : 0
	self.votes.any? ? self.votes.average(:value).round(1) : 0
  end
  def cahed_avarage_vote
	Rails.cache.fetch([self,"avarage_vote"]) { self.votes.any? ? self.votes.average(:value).round(1) : 0 }
  end
  
  def cached_vote_count
	Rails.cache.fetch([self, "vote_count"]) { votes.size }
  end
  def self.cached_find_by(id)
	Rails.cache.fetch([name, id]) { find_by(id: id) }
  end
  
  def cached_ingredients
	Rails.cache.fetch([self, "ingredients"]) { self.ingredients.to_a }
  end
  def cached_directions
	Rails.cache.fetch([self, "directions"]) { self.directions.to_a }
  end
  def cached_votes
	Rails.cache.fetch([self, "votes"]) { self.votes.to_a }
  end
end