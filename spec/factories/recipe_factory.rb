FactoryBot.define do
  factory :recipe, class: 'Recipe' do
    title { "turkey food" }
    description { "turkey food description" }
    chef_name { "Monica" }
    marley_spoon_recipe_id { 3 }
  end
end
