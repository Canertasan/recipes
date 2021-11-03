class RecipesController < ApplicationController
  def index
    @recipes = Recipe.get_recipes
  end
end
