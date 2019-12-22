class Address < ApplicationRecord
  belongs_to :user, optional: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  #新規登録のバリデーション
  VALID_PHONE_REGEX = /\A\d{10}$|^\d{11}\z/ #電話番号ハイフンなし10桁か11桁
  # #address
  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_cord, :prefecture_id, :city, :block, presence: true
  validates :last_name_kana, format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :first_name_kana, format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :postal_cord, format:{ with: /\A\d{3}[-]\d{4}\z/, allow_blank: true } #ハイフンあり7桁
  validates :phone_number, format:{ with: VALID_PHONE_REGEX, allow_blank: true }

end
