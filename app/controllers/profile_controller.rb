class ProfileController < ApplicationController

  def edit
  end
  
  def logout #ログアウトのビューの為に作成
  end

  def mypage #マイページのビューの為に作成
    @user = User.find(current_user.id)
  end

end
