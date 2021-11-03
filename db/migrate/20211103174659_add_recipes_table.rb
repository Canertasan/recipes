class AddRecipesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes, id: :serial do |t|
      t.string :marley_spoon_recipe_id
      t.string :title
      t.string :image
      t.string :tags, default: [], array: true
      t.string :description
      t.string :chef_name

      t.timestamps
    end
  end
end
