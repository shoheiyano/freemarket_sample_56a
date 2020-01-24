class Item < ApplicationRecord

  # has_one_attached :image #ActiveStrage 1つの添付ファイルの場合
  has_many_attached :images #ActiveStrage 複数の添付ファイルの場合
  belongs_to :user, optional: true
  has_many :likes
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  #ここから出品ページでのアソシエーション
  has_many :items_categories
  has_many :categories, through: :items_categories

  ##ここから出品ページでのバリデーション
  # validates :trade_name, presence: true, length: { in: 1..40 }
  # validates :description, presence: true, length: { maximum: 1000 }
  # validates :images, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, presence: true
  # validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }

end
