require 'rails_helper'

RSpec.describe "Recipes", type: :request do

  describe "GET /index" do
    it 'fetch request' do
      get '/recipes'
      # fetch request here
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    it 'find recipe' do
      recipe = FactoryBot.create(:recipe)
      get "/recipes/#{recipe.marley_spoon_recipe_id}"

      expect(response).to have_http_status(:ok)
    end
  end
end
