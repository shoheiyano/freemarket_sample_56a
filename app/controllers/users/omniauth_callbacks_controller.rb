# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end


  def facebook
    callback_for(:facebook)
  end

  def google_oauth2
    callback_for(:google)
  end

  #userモデルでsnsから取得した情報を元にデータベースでユーザーを探し、なければ作る
  def callback_for(provider)
    @omniauth = request.env['omniauth.auth'] #userモデルでsnsから取得したnickname,email,uid,provider,tokenなどが入っている
    info = User.find_oauth(@omniauth) #infoの中身は、@omniauthの中からuserテーブル、sns_credentialsテーブルに保存する分が入っている。:user,:snsの形なのでinfo[:user]ならuserテーブルに入れる情報が取れる
    @user = info[:user] #@omniauthからuserテーブルに入れる分が入っている。nicknameとemailが入っている。
   
    if @user.persisted? #@userがsave済みであるかの確認
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
     
    else #@userがsave済みじゃなければこっちにくる
      @sns = info[:sns] #@omniauthのうち、sns_credentialsテーブルに入れる分を取って@snsに渡す。uid,provider。
      session[:sns] = @sns
      # binding.pry
      render template: "signup/registration" #@user,@snsの情報を持って新規会員登録ページにとぶ。nickname,email,uid,providerを持ってる。
       #passwordが発行されても新規登録画面に出てこない
    end
  end

  def failure
    redirect_to root_path and return
  end

end



