Rails.application.routes.draw do

  root to: 'items#index'
  devise_for :users
  get 'mypage/identification', action: :edit, controller: 'identification'
  get 'mypage/profile', action: :edit, controller: 'profile'
  get "logout" => "profile#logout"
  get 'mypage' => 'profile#mypage'
  get 'mypage/card', action: :new, controller: 'card'
  resources :items, only: [:index,:new,:search,:show,:create,:edit,:destroy]
  resources :buy, only: [:show]
  #ユーザー各種新規登録画面
  resources :signup do
    collection do
      get 'registration' #会員情報
      get 'sms_confirmation' #電話番号認証
      get 'address' #住所入力
      post 'address'
      # get 'credit_card' #支払い方法
      get 'done' # 登録完了後のページ
      post 'done'
    end
  end
end
