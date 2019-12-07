class SignupController < ApplicationController

  # before_action :save_step1_to_session, only: :step2
  # before_action :save_step2_to_session, only: :step3

  def registration
    @user = User.new #毎回新しいのを作る
    @user.build_address #親userモデルと子addressモデルを関連づける
  end

  # step1バリデーション
  # def save_step1_to_session
  #   session[:user_params] = user_params
  #   session[:address_attributes_after_step1] = user_params[:address_attributes]
  #   @user = User.new(session[:user_params])
  #   @user.build_address(session[:address_attributes_after_step1])
  #   render '/signup/step1' unless @user.valid?
  #   # binding.pry
  # end 

  def sms_confirmation
    session[:user_params] = user_params #step1で入力したuserモデルに関する情報
    # binding.pry
    session[:address_attributes_after_registraiton] = user_params[:address_attributes] #step1で入力したaddressモデルの関する情報を名前を変えてsessionに入れる。
    # binding.pry
    @user = User.new
    @user.build_address
  end

  # step2バリデーション
  # def save_step2_to_session
  #   session[:address_attributes_after_step2] = user_params[:address_attributes]
  #   session[:address_attributes_after_step2].merge!(session[:address_attributes_after_step1])
  #   @user = User.new
  #   @user.build_address(session[:address_attributes_after_step2])
  #   render '/signup/step2' unless session[:address_attributes_after_step2][:phone_number].present?
  # end


  def address
    session[:address_attributes_after_sms] = user_params[:address_attributes] #step2で入力したaddressモデルの情報をsessionに入れる。上書きしないように名前はstep1と被らないようにする。
    # binding.pry
    session[:address_attributes_after_sms].merge!(session[:address_attributes_after_registraiton]) #step2のaddressモデル情報にstep1のaddressモデル情報を入れて一つにまとめる。
    # binding.pry  #step2のsession入力内容が確認できた。
    @user = User.new
    @user.build_address
  end

  #step3バリデーション
  # def save_step3_to_session
  #   session[:address_attributes_after_step3] = user_params[:address_attributes]
  #   session[:address_attributes_after_step3].merge!(session[:address_attributes_after_step2])
  #   @user = User.new
  #   @user.build_address(session[:address_attributes_after_step3])
  #   render '/signup/step3' unless session[:address_attributes_after_step3][:postal_cord].present? && session[:address_attributes_after_step3][:prefecture_id].present? && session[:address_attributes_after_step3][:city].present? && session[:address_attributes_after_step3][:block].present?
  # end

  def create
    session[:address_attributes_after_sms].merge!(user_params[:address_attributes]) #step3で入力したuser_paramsをsession[:address_attributes_after_step2]に含めて一つにする
    # binding.pry 
    @user = User.new(session[:user_params]) #step1のuserモデルに関する情報が入ったsessionを渡す。userテーブルに情報を保存する。
    # binding.pry
    @user.build_address(session[:address_attributes_after_sms]) #addressテーブルに情報を保存する。 #このあとに@user.buidl_address(sessionでもuser_paramsでも)と書いてしまうと同じ名前=上書きされるので必ずmergeすること
    # @user.build_address(user_params)←これはだめ。上の@user.build_addressに上書きされてしまう=addressテーブルに必要な情報が保存されない。
    # binding.pry
    if @user.save #もしデータベース保存に成功したら
      session[:id] = @user.id #user_idをsessionに入れてログイン状態にする。
      redirect_to done_signup_index_path #登録完了画面に飛ぶ。
    else #saveしなかったら
      render 'signup/registration' #step1に飛ぶ。
    end
  end

  def done
    sign_in User.find(session[:id]) unless user_signed_in?
  end

  private
  def user_params #step1~step3でユーザーが入力する項目
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, address_attributes: [:id, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number, :postal_cord, :prefecture_id, :city, :block, :building])
  end

end
