class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :size
  belongs_to :brand
  has_many :photos
  has_many :likes
  has_one :order
end
