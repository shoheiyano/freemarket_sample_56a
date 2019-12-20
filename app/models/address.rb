class Address < ApplicationRecord
  belongs_to :user, optional: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  #新規登録のバリデーション
  VALID_PHONE_REGEX = /\A\d{10}$|^\d{11}\z/ #電話番号ハイフンなし10桁か11桁
  # #address
  validates :last_name,       presence: true
  validates :first_name,      presence: true
  validates :last_name_kana, 
    presence: true, 
    format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :first_name_kana, 
    presence: true, 
    format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :postal_cord, 
    presence: true, 
    format:{ with: /\A\d{3}[-]\d{4}\z/, allow_blank: true } #ハイフンあり7桁
  validates :prefecture_id,   presence: true
  validates :city,            presence: true
  validates :block,           presence: true
  validates :phone_number, format:{ with: VALID_PHONE_REGEX, allow_blank: true }

end
