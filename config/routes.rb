Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'items#index'
  devise_for :users
  get 'mypage/identification', action: :edit, controller: 'identification'
  get 'mypage/profile', action: :edit, controller: 'profile'
  get "logout" => "profile#logout"

  #ユーザー各種新規登録画面
  devise_scope :user do
    get 'users/sign_up/registration' => 'users/registrations#new_1'
    get 'users/sign_up/sms_confirmation' => 'users/registrations#new_2'
    get 'users/sign_up/sms_confirmation/sms' => 'users/registrations#new_3'
    get 'users/sign_up/address' => 'users/registrations#new_4'
    get 'users/sign_up/credit_card' => 'users/registrations#new_5'
    get 'users/sign_up/done' => 'users/registrations#new_6'
  end
end