class Direction < ActiveRecord::Base
  belongs_to :recipe, touch: true
end
