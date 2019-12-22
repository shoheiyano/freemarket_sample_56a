class SignupController < ApplicationController

  require "payjp"

  before_action :validate_registration, only: :sms_confirmation #sms_confirmationに行く前にregistrationのバリデーションチェック
  before_action :validate_sms_confirmation, only: :address #addressに行く前にsms_confirmationのバリデーションチェック
  before_action :validate_address, only: :credit_card #credit_cardに行く前にaddressのバリデーションチェック
  

  def registration
    @user = User.new
  end

  # registrationバリデーション
  def validate_registration
    session[:user_params_registration] = user_params #registrationで入力したuserモデルに関する情報
    
    @user = User.new(nickname: session[:user_params_registration][:nickname],
                     email: session[:user_params_registration][:email],
                     password: session[:user_params_registration][:password],
                     password_confirmation: session[:user_params_registration][:password_confirmation],
                     last_name: session[:user_params_registration][:last_name],
                     first_name: session[:user_params_registration][:first_name],
                     last_name_kana: session[:user_params_registration][:last_name_kana],
                     first_name_kana: session[:user_params_registration][:first_name_kana],
                     birth_year: session[:user_params_registration][:birth_year],
                     birth_month: session[:user_params_registration][:birth_month],
                     birth_day: session[:user_params_registration][:birth_day],
                     #userモデルのバリデーションを通過するための仮置き
                     phone_number: '09012341234')

    # できたら覚書として残したいです。
    # session[:user_params_registration]) #もしregistrationがaddressモデルと関連づけていたらsession[:user_params_registration]の中身はこうなっている。
    # @user.build_address(last_name: session[:user_params][:address_attributes][:last_name],
    #                     first_name: session[:user_params][:address_attributes][:first_name],
    #                     last_name_kana: session[:user_params][:address_attributes][:last_name_kana],
    #                     first_name_kana: session[:user_params][:address_attributes][:first_name_kana],
    #                     birth_year: session[:user_params][:address_attributes][:birth_year],
    #                     birth_month: session[:user_params][:address_attributes][:birth_month],
    #                     birth_day: session[:user_params][:address_attributes][:birth_day],

    render '/signup/registration' unless @user.valid? #失敗した時のビュー呼び出しはroutesを通さないrenderを使う。routeを通すと再度アクションが動いてページが更新されて入力値が消えてしまうため。
  end 

  def sms_confirmation
    @user = User.new
  end

  # sms_confirmationバリデーション
  def validate_sms_confirmation
    session[:user_params_sms_confirmation] = user_params #sms_confirmationで入力された情報
    session[:user_params_sms_confirmation].merge!(session[:user_params_registration]) #registrationで入力した情報を今回の入力内容に加える
  
    @user = User.new(nickname: session[:user_params_sms_confirmation][:nickname],
                     email: session[:user_params_sms_confirmation][:email],
                     password: session[:user_params_sms_confirmation][:password],
                     password_confirmation: session[:user_params_sms_confirmation][:password_confirmation],
                     last_name: session[:user_params_sms_confirmation][:last_name],
                     first_name: session[:user_params_sms_confirmation][:first_name],
                     last_name_kana: session[:user_params_sms_confirmation][:last_name_kana],
                     first_name_kana: session[:user_params_sms_confirmation][:first_name_kana],
                     birth_year: session[:user_params_sms_confirmation][:birth_year],
                     birth_month: session[:user_params_sms_confirmation][:birth_month],
                     birth_day: session[:user_params_sms_confirmation][:birth_day],
                     phone_number: session[:user_params_sms_confirmation][:phone_number])

    render '/signup/sms_confirmation' unless @user.valid?
    # binding.pry
  end


  def address
    @user = User.new
    @user.build_address
  end

  #addressバリデーション
  def validate_address
    session[:address_attributes_after_address] = user_params[:address_attributes]

    @user = User.new(session[:user_params_sms_confirmation]) #validate_sms_confirmationと同じ中身
    @user.build_address(session[:address_attributes_after_address]) #中身はaddressで入力した情報
    
    render '/signup/address' unless @user.valid?
  end

  def credit_card
    @user = User.new
    @user.build_card
  end

  def create
    @user = User.new(session[:user_params_sms_confirmation]) #step1のuserモデルに関する情報が入ったsessionを渡す。userテーブルに情報を保存する。
    @user.build_address(session[:address_attributes_after_address]) #addressテーブルに情報を保存する。 #このあとに@user.buidl_address(sessionでもuser_paramsでも)と書いてしまうと同じ名前=上書きされるので必ずmergeすること
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #テスト秘密鍵の環境変数
    
    if params['payjp-token'].blank? #pyajp-tokenが空または存在しないか判定している（blank?はnilと空のオブジェクトを判定できる）
      redirect_to credit_card_signup_index_path
    else
      customer = Payjp::Customer.create(card: params['payjp-token'])
      @user.build_card(customer_id: customer.id, card_id: customer.default_card)   
    if @user.save
      session[:id] = @user.id #user_idをsessionに入れてログイン状態にする。
      redirect_to done_signup_index_path #登録完了画面に飛ぶ。
    else #saveしなかったら
      render 'signup/registration' #registrationに飛ぶ。
    end
  end
end


  def done #登録完了ページ ログイン状態を継続する
    sign_in User.find(session[:id]) unless user_signed_in?
  end

  private
  def user_params #registration~credit_cardでユーザーが入力した項目のうちDBに登録したい項目
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number, address_attributes: [:id, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_cord, :prefecture_id, :city, :block, :building, :phone_number], card_attributes:[:customer_id, :card_id])
  end

end
