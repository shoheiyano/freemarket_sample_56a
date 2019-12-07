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
  get "signup", to: "signup#index"
  resources :signup do
    collection do
      get 'registration' #新規会員登録入力画面（userテーブルに登録したい情報）
      post 'sms_confirmation' #携帯電話番号の入力（addressテーブルに登録したい情報）
      post 'address'   #お届け先住所の入力（addressテーブルに登録したい情報）最後の入力ページ
      # get 'credit_card'           #クレジットカード 他がデータベース登録できるようになってから実装する。
      get 'done' #登録完了
    end
  end
end
