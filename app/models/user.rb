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
  def self.without_sns_data(auth) #self.find_oauth(auth)から飛んでくる
    #snsから取ってきたemailがuserモデルにあるか探してuserに渡す。なければnilが入る。
    user = User.where(email: auth.info.email).first
    
      if user.present? #userの中身がnilの場合if以下の処理がスキップしてelseに行く
        
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
        
      else #ifから飛んでくる
        #snsから取ってきた情報でuserテーブルに登録するレコードを新しく作ってuserに渡す
        user = User.new(
          nickname: auth.info.name, #snsから取ってきた名前がuserテーブルのnicknameになる
          email: auth.info.email, #snsから取ってきたメールアドレスがuserテーブルのemailになる
        )
        sns = SnsCredential.new(
          uid: auth.uid, #snsから取ってきたuidがsns_credentialsテーブルのuidになる
          provider: auth.provider, #snsから取ってきたproviderがsns_credentialsテーブルのproviderになる
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
      )
      
    end
    return {user: user}
    
   end

   #sns認証で新規登録ボタンを押すとまずここに飛んでくる
   def self.find_oauth(auth)
    #snsからuidとproviderを持ってきてそれぞれ渡す
    uid = auth.uid #userの番号
    provider = auth.provider #googleかfacebook
    #snsからとってきたuidとproviderがsnscredentialモデルに入っていたら取り出して渡す
    snscredential = SnsCredential.where(uid: uid, provider: provider).first #snscredentialモデルに登録している情報がなければsnscredentialの中身はnilになる
   
    if snscredential.present? #snscredentialがnilの場合ifの処理はスキップする。登録したことがなければelse以下もスキップしてself.without_sns_data(auth)にとぶ
      
      user = with_sns_data(auth, snscredential)[:user] #57行目からきた場合、snsから取得したnicknameとemailが入っている。
      sns = snscredential #57行目からきた場合、snsから取得したuidとproviderが入っている

    else
      user = without_sns_data(auth)[:user] #35行目のuserで取得したuserが入っている
      sns = without_sns_data(auth)[:sns] #上に同じくsnsが入っている
      
    end
    return { user: user ,sns: sns}
   
  end

end
