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

  #雉野追記、itemモデルで購入者と出品者を取り出せるようにする。usersテーブルのidとitemsテーブルのbuyer_idとseller_idを紐づける
  # belongs_to :seller, class_name: "User"
  # belongs_to :buyer, class_name: "User" #これがあると出品ができなくなるのでコメントアウト

  ##ここから出品ページでのバリデーション
  # validates :trade_name, presence: {message:"入力してください"}, length: { maximum: 40 }
  # validates :description, presence: {message:"入力してください"}, length: { maximum: 1000 }
  # validates :condition, :postage, :delivery_method, :prefecture_id, :shipment_date, presence: {message:"選択してください"}
  # validates :price, presence: {message:"300以上9999999以下で入力してください"}

end
