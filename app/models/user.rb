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
  validates :nickname, :email, :password, :password_confirmation, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number, presence: true
  validates :email, format:{ with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length:{minimum:7}
  validates :password_confirmation, length:{minimum:7}
  validates :last_name_kana, format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ
  validates :first_name_kana, format: { with: /\A([ァ-ン]|ー)+\z/, allow_blank: true } #カタカナ

  # #sms_confirmation
  validates :phone_number, format: { with: /\A\d{11}\z/, allow_blank: true } #ハイフンなし11桁


  #SNS認証のために記入
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    sns_credential_record = SnsCredential.where(provider: auth.provider, uid: auth.uid)
    if user.present?
      unless sns_credential_record.present?
        SnsCredential.create(
          user_id: user.id,
          provider: auth.provider,
          uid: auth.uid
        )
      end
    elsif
      user = User.new(
        id: User.all.last.id+1,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        nickname: auth.info.name,
        last_name: auth.info.last_name,
        first_name: auth.info.first_name,
      )
      SnsCredential.new(
        provider: auth.provider,
        uid: auth.uid,
        user_id: user.id
      )
    end
    user
  end
#   def self.find_oauth(auth)
#     uid = auth.uid
#     provider = auth.provider
#     snscredential = SnsCredential.where(uid: uid, provider: provider).first

#     if snscredential.present?
#       user = User.where(email: auth.info.email).first

#       unless user.present?
#         user = User.new(
#           nickname: auth.info.name,
#           email: auth.info.email,
#         )
#       end
#       sns = snscredential
#       { user: user, sns: sns}
      
#     else
#       user = User.where(email: auth.info.email).first

#       if user.present?
#         sns = SnsCredential.create(
#           uid: uid,
#           provider: provider,
#           user_id: user.id
#         )
#         {user: user, sns: sns}
#       else
#         user = User.new(
#           nickname: auth.info.email,
#           email: auth.info.email,
#         )
#         sns = SnsCredential.new(
#           uid: uid,
#           provider: provider
#         )
#         {user: user, sns: sns}
#       end
#     end
#   end
# end
  # def self.without_sns_data(auth) #2番目に動いた 新規登録だとself.find_oauth(auth)からif以下に行かずここにとぶ.authの中身は1番目と同じ
  #   user = User.where(email: auth.info.email).first #auth.info.emailでSMSに登録しているメールアドレス。それをuserモデルにいれる
  #   # binding.pry
  #     if user.present? #userが登録されている場合
  #       sns = SnsCredential.create(
  #         uid: auth.uid,
  #         provider: auth.provider,
  #         user_id: user.id
  #       )
  #       # binding.pry
  #     else #userが登録されていない
  #       user = User.new(
  #         nickname: auth.info.name,
  #         email: auth.info.email,
  #       )
  #       sns = SnsCredential.new(
  #         uid: auth.uid,
  #         provider: auth.provider
  #       )
  #     end
  #     return { user: user ,sns: sns}
  #   end

  #  def self.with_sns_data(auth, snscredential)
  #   user = User.where(id: snscredential.user_id).first
  #   # binding.pry
  #   unless user.present? #userが登録されていない場合
  #     user = User.new(
  #       nickname: auth.info.name,
  #       email: auth.info.email,
  #       #ここにパスワードを自動生成するコードを書く？
  #     )
  #   end
  #   return {user: user}
  #  end

  #  #self=クラスメソッド Userクラスに働きかけている #１番に動いた
  #  def self.find_oauth(auth) #authの中身=SNSの登録情報(email,name,image,tokenなど)
  #   uid = auth.uid #各プロバイダーの番号
  #   provider = auth.provider #facebookかgoogle
  #   snscredential = SnsCredential.where(uid: uid, provider: provider).first #sns_credentialモデルに取得したuid、providerの情報があるかどうか調べる
  #   # binding.pry
  #   if snscredential.present? #sns_credentialsが登録されている場合
  #     user = with_sns_data(auth, snscredential)[:user] 
  #     sns = snscredential
  #     # binding.pry
  #   else
  #     user = without_sns_data(auth)[:user]
  #     sns = without_sns_data(auth)[:sns]
  #     # binding.pry
  #   end
  #   return { user: user ,sns: sns}
  #   # binding.pry
  # end
end
