require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it 'validate recipe' do
    i = FactoryBot.build(:recipe)
    expect(i).to be_valid
  end
end
