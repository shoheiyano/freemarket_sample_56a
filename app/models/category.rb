class Category < ApplicationRecord
  # has_many :items_categories
  # has_many :items, through: :items_categories
  has_many :items
  has_ancestry
end
