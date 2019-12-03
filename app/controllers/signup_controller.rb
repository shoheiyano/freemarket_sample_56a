class SignupController < ApplicationController

  def registration
    @user = User.new
  end

  def sms_confirmation
    #registrationで入力した情報をsessionに保存
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:password_confirmation] = user_params[:password_confirmation]
    session[:last_name] = user_params[:last_name]
    session[:first_name] = user_params[:first_name]
    session[:last_name_kana] = user_params[:last_name_kana]
    session[:first_name_kana] = user_params[:first_name_kana]
    session[:birthday] = user_params[:birthday]
    @user = User.new 
  end

  def address
    #sms_confirmationで入力した情報をsessionに保存
    session[:phone_number] = user_params[:phone_number]
    @user = User.new
    @user.build_address #userモデルと関連づける　fields_forを記述したビューを呼び出すアクションに記述する
  end

  # def credit_card
  #   session[:address_attributes_after_address] = user_params[:address_attributes]
  #   session[:profile_attributes_after_address].merge!(session[:address_attributes_after_registration])
  #   @user = User.new
  #   @user.build_profile
  # end

  def done

  end

  def create
    @user = User.new(
      nickname: session[:nickname],
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      last_name: session[:last_name],
      first_name: session[:first_name],
      last_name_kana: session[:last_name_kana],
      first_name_kana: session[:first_name_kana], #ここまでregistrationで入力された値　インスタンスに渡す
      phone_number: session[:phone_number], #sms_confirmationで入力した値　インスタンスに渡す
    )
    @user.build_address(
      #お届け先住所登録(address)で入力した値が設定できていません...
      id: session[:id],
      last_name: session[:last_name],
      first_name: session[:first_name],
      last_name_kana: session[:last_name_kana],
      first_name_kana: session[:first_name_kana],
      postal_cord: session[:postal_code],
      prefecture: session[:prefecture],
      block: session[:block],
      building: session[:building],
      phone_number: session[:phone_number],
    )
    if @user.save
      session[:user_id] = @user.id
      redirect_to done_signup_index_path
    else
      render '/signup/registration'
    end
  end


  private

  def user_params
    params.require(:user).permit(
      :nickname,
      :email,
      :password,
      :password_confirmation,
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :birthday,
      :phone_number,
      address_attributes: [:id, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_cord, :prefecture, :block, :building, :phone_number]
    )
  end
end
