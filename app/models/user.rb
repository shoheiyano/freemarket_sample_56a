class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  has_many :items

  has_one :address
  accepts_nested_attributes_for :address

  has_one :profile
  
  has_many :sns_credentials, dependent: :destroy
  
  has_one :card
  accepts_nested_attributes_for :card

  #新規登録画面バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #registration
  validates :nickname, presence: true
  validates :email, 
    presence: true, 
    format:{ with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length:{minimum:7}, presence: true
  validates :password_confirmation, length:{minimum:7}, presence: true
  validates :last_name,       presence: true
  validates :first_name,      presence: true
  validates :last_name_kana, 
    presence: true, 
    format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :first_name_kana, 
    presence: true, 
    format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :birth_year,      presence: true
  validates :birth_month,     presence: true
  validates :birth_day,       presence: true
  # #sms_confirmation
  validates :phone_number, 
    presence: true, 
    format: { with: /\A\d{11}\z/, allow_blank: true } #ハイフンなし11桁


  #SNS認証のために記入
  def self.without_sns_data(auth) #2番目に動いた
    user = User.where(email: auth.info.email).first
    # binding.pry
      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
        # binding.pry
      else
        user = User.new(
          nickname: auth.info.name,
          email: auth.info.email,
        )
        sns = SnsCredential.new(
          uid: auth.uid,
          provider: auth.provider
        )
      end
      return { user: user ,sns: sns}
    end

   def self.with_sns_data(auth, snscredential)
    user = User.where(id: snscredential.user_id).first
    unless user.present?
      user = User.new(
        nickname: auth.info.name,
        email: auth.info.email,
        #ここにパスワードを自動生成するコードを書く？
      )
      # user.build_address #addressテーブル分のformを表示させたいけどわからない
    end
    return {user: user}
   end

   def self.find_oauth(auth) #self=クラスメソッド Userクラスに働きかけている #１番に動いた
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    # binding.pry
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user]
      sns = snscredential
    else
      user = without_sns_data(auth)[:user]
      sns = without_sns_data(auth)[:sns]
    end
    return { user: user ,sns: sns}
  end
end
