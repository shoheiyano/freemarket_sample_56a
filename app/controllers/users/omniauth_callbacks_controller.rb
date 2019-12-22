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
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to registration_signup_index_path
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'google') if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"][:info]
      redirect_to registration_signup_index_path
    end
  end

#   def facebook
#     callback_for(:facebook)
#   end

#   def google_oauth2
#     callback_for(:google)
#   end

#   # common callback method
#   def callback_for(provider)
#     info = User.find_oauth(request.env["omniauth.auth"])
#     # snsの情報からuserが登録されているか or snsから情報を取得できているかを確認
#     @user = User.where(nickname: info[:user][:nickname]).or(User.where(email: info[:user][:email])).first || info[:user]

#     # persisted?はデータがDBに保存されているかを確認する/配列に対しては使えないから@userを定義するときは気をつける
#     if @user.persisted?
#       #保存されていればログインしてroot_pathにリダイレクトされる
#       sign_in_and_redirect @user, event: :authentication
#       set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
#     else
#       # 登録するアクションに取得した値を渡すために。sessionを利用してuserインスタンスを作成する
#       session[:nickname] = info[:user][:nickname]
#       session[:email] = info[:user][:email]

#       #snsでのユーザ登録ではパスワードを入力させないので準備する。パスワードを作成するDeviseメソッドもある。
#       #今回のバリデーションは英数字のみなのでこっちを採用
#       session[:password_confirmation] = SecureRandom.alphanumeric(30)

#       #SnsCredentialが登録されていないとき
#       if SnsCredential.find_by(uid: info[:sns][:uid], provider: info[:sns][:provider]).nil?
#         #ユーザ登録と同時にsns_credentialも登録するために
#         session[:uid] = info[:sns][:uid]
#         session[:provider] = info[:sns][:provider]
#       end
#       #登録フォームのviewにリダイレクトさせる
#       redirect_to registration_signups_path
#     end
#   end

#   def failure
#     redirect_to root_path
#   end
# end

  # def facebook
  #   callback_for(:facebook)
  #   # binding.pry #4番目に動いた
  # end

  # def google_oauth2
  #   callback_for(:google)
  # end


  # def callback_for(provider)
  #   @omniauth = request.env['omniauth.auth']
  #   info = User.find_oauth(@omniauth) #infoにはuser(emailとnickname)、sns(providerとuid)が入っている
  #   @user = info[:user] #userモデルに入れるemailとnicknameを取得している
  #   # binding.pry #3番目に動いた
  #   if @user.persisted? 
  #     # binding.pry
  #     sign_in_and_redirect @user, event: :authentication
  #     set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #     # binding.pry
  #   else 
  #     @sns = info[:sns]
  #     render "signup/registration/"
  #     # binding.pry
  #   end
  # end

  # def failure
  #   redirect_to root_path and return
  # end
end

