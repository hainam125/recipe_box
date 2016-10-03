class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :name
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
