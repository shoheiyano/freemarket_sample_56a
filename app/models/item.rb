class Item < ApplicationRecord
  has_many_attached :images
  belongs_to :user, optional: true
  has_many :likes
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  #ここから出品ページでのアソシエーション
  has_many :items_categories
  has_many :categories, through: :items_categories
  # belongs_to :category
  # has_many :photos, dependent: :destroy #雉野追記、dependent: :destroyは紐づいている親モデル側のみに書く。子モデル（この場合photo）には書かない
  # accepts_nested_attributes_for :photos, allow_destroy: true

  #雉野追記、itemモデルで購入者と出品者を取り出せるようにする。usersテーブルのidとitemsテーブルのbuyer_idとseller_idを紐づける
  # belongs_to :seller, class_name: "User"
  # belongs_to :buyer, class_name: "User" #これがあると出品ができなくなるのでコメントアウト

  ##ここから出品ページでのバリデーション
  validates :trade_name, presence: true, length: { in: 1..40 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :images, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }

end
