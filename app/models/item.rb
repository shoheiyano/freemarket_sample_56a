class Item < ApplicationRecord
  belongs_to :user, optional: true
  has_many :likes
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  #ここから出品ページでのアソシエーション
  has_many :items_categories
  has_many :categories, through: :items_categories
  belongs_to :size, optional: true
  accepts_nested_attributes_for :size
  belongs_to :brand, optional:true
  accepts_nested_attributes_for :brand
  has_many :photos
  accepts_nested_attributes_for :photos

  ##ここから出品ページでのバリデーション
  validates :trade_name, presence: {message:"入力してください"}, length: { maximum:40 }, on: create
  validates :description, presence: {message:"入力してください"}, length: { maximum:1000 }, on: create
  validates :condition, :postage, :delivery_method, :prefecture_id, :shipment_date, presence: {message:"選択してください"}, on: create
  validates :price, presence: {message:"300以上9999999以下で入力してください"}, on: create

end
