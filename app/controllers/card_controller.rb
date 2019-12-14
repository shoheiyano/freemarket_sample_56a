class CardController < ApplicationController

  require "payjp"

  def new
    card = Card.where(user_id: current_user.id) #cardモデルからcurrent_user.id=user_idに当てはまるレコードがあるか
    redirect_to action: "show" if card.exists? #すでに同じuser_idのcardが存在（exists）するならshowアクションに飛ぶ
  end

  def pay
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #テスト秘密鍵の環境変数
    if params['payjp-token'].blank? #pyajp-tokenが空または存在しないか判定している（blank?はnilと空のオブジェクトを判定できる）
      redirect_to action: "new" #もしpayjp-tokenが空（未入力？）ならnewアクションへ飛ぶ
    else
      customer = Payjp::Customer.create(  #payjp::Customer.createで顧客作成→()の情報で作成されたトークンを用いて顧客情報を導入している？
        email: current_user.email,
        card: params['payjp-token'], #入力されたpayjp-token（params）を持ったcard
        metadata: {user_id: current_user.id} #user_id=current_user.idのメタデータ
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "show" #cardが保存できたらshowアクションへ飛ぶ
      else
        redirect_to action: "pay" #保存できなかったらpayアクションやり直し
      end
    end
  end

  def delete
    card = Card.where(user_id: current_user.id).first #該当するuser_idのカードテーブルの最初の一件
    if card.blank? #カードは空または存在しているか判定している
    else #カードが存在するなら
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #テスト秘密鍵
      customer = Payjp::Customer.retrieve(card.customer_id) #retrieve（翻訳：取り戻す）が調べてもわからず
      customer.delete #作成した顧客を削除
      card.delete #カードも削除
    end
      redirect_to action: "new" #カードが存在しなくなったらnewアクションへ飛ぶ
  end

  def show
    card = Card.where(user_id: current_user.id).first #該当するuser_idのカードテーブルの最初の一件
    if card.blank? #カードは空または存在しているか判定している
      redirect_to action: "new" #空ならnewへ飛ぶ
    else
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #テスト秘密鍵
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end
end
