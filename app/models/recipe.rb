require "http"

class Recipe < ApplicationRecord
  SECRETS = Rails.application.secrets

  def self.get_and_save_recipes
    response = HTTP.get("https://cdn.contentful.com/spaces/#{SECRETS.space_id}/entries?access_token=#{SECRETS.access_token}")
    @recipes = []
    @images = []
    @tags = []
    @chefs = []

    if response.parse(:json)["items"]
      response.parse(:json)["items"].each do |item|
        item_type = item.dig("sys", "contentType", "sys", "id")
        if item_type == "recipe"
          @recipes.push(item)
        elsif item_type == "tag"
          @tags.push(item)
        elsif item_type == "chef"
          @chefs.push(item)
        end
      end
    end

    if !response.parse(:json).dig("includes", "Asset").nil?
      response.parse(:json)["includes"]["Asset"].each do |item|
        @images.push(item)
      end
    end

    created_recipes = []

    @recipes.each do |recipe|
      fields = recipe["fields"]
      current_tags = []
      if fields["tags"]
        fields["tags"].each do |tag|
          tag_name = find_chef_or_tag_name(tag.dig("sys", "id"), "tag")
          current_tags.push(tag_name) unless tag_name.nil?
        end
      end
      ms_recipe_id = recipe.dig("sys", "id")
      new_recipe = Recipe.new({
        marley_spoon_recipe_id: ms_recipe_id,
        title: fields["title"],
        image: find_image_url(fields.dig("photo", "sys", "id")),
        tags: current_tags,
        description: fields["description"],
        chef_name: find_chef_or_tag_name(fields.dig("chef", "sys", "id"), "chef"),
      })
      created_recipes.push(new_recipe)
      new_recipe.save! unless is_recipe_exist(ms_recipe_id) # this is for extra, when ever new recipe comes
      # in the domain then i will take this and put the database, but simply show what is currently
      # on the domain

      # so in every recipe i try to get it make a where request which causes lots of trouble(like n request)
      # instead of doing that i think i can make 'validates :marley_spoon_recipe_id, 
      # presence: true, uniqueness: true' that will be more efficient. then we can ignore the catch error
      # and ignore it
    end

    created_recipes
  end

  def self.is_recipe_exist(ms_recipe_id)
    return false if Recipe.where(marley_spoon_recipe_id: ms_recipe_id).blank?

    return true
  end

  def self.find_image_url(current_id)
    return if current_id == nil

    @images.each do |image|
      return image.dig("fields", "file", "url") if image.dig("sys", "id") == current_id
    end

    return nil
  end

  def self.find_chef_or_tag_name(current_id, type)
    search_arr = if type == "chef"
               @chefs
             elsif type == "tag"
               @tags
             end

    search_arr.each do |element|
      return element.dig("fields", "name") if element.dig("sys", "id") == current_id
    end

    return nil
  end

end
