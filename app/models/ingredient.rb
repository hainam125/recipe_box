class Ingredient < ActiveRecord::Base
  belongs_to :recipe, touch: true
end
