class RecipesController < ApplicationController
  def index
    @recipes = Recipe.get_and_save_recipes
  end

  def show
    @recipe = Recipe.where(marley_spoon_recipe_id: params[:id]).last
  end
end
