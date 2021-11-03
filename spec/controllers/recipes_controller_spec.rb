require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  SECRETS = Rails.application.secrets

  describe "GET /index" do
    it 'fetch request' do
      expect do
        get '/recipes'
      end.to change(Recipe, :count).by(4)
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
