class ItemsController < ApplicationController

  require 'payjp'

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    # @item.size
    # @item.brand
    @item_photo = @item.photos.build #子モデルのphotoを保存させるための記述。_buildの書き方でエラーが出ました。コネクトで聞いた結果、同じ意味である左記の記述で書いてあります。
  end

  def search
    if params[:parent_id]
      @children = Category.find(params[:parent_id]).children
    # 親カテゴリーのidから子カテゴリーのidの配列を作成してインスタンス変数で定義
    else
      @grandchildren = Category.find(params[:child_id]).children
    # 子カテゴリーのidから孫カテゴリーのidの配列を作成してインスタンス変数で定義
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @item = Item.new(item_params)
      if @item.save
        redirect_to root_path
    # if @item.save!
    #   size_id = Size.find(@item.id).id
    #   brand_id = Brand.find(@item.id).id
    #   item = Item.find(@item.id)
    #   item.update(size_id: size_id)
    #   item.update(brand_id: brand_id)
    #   redirect_to root_path
    else
      redirect_to new_item_path
    end
  end

  def show
    @items = Item.find(params[:id])
  end

  #商品購入のため雉野追記
  def buy
    @items = Item.find(params[:id]) #URLのidとitemテーブルのidが同じ情報を@itemsに入れる。
    @buyer = Address.find_by(user_id: current_user.id) #購入者の配送先住所を取得する
    # @buyer_prefecrure = Prefecture.find_by(id: @buyer.prefecture) #prefectureモデルからidをもとにname(名前)を引っ張ってきたい
    card = Card.where(user_id: current_user.id).first #cardテーブルから現在ログインしているユーザーのidのuser_idをcardに入れる id,user_id,customer_id,card_idが入っている。
    # binding.pry
    if card.blank? #テーブルに登録されたカード情報がなければ
      redirect_to controller: "card", action: "new" #card_controllerのnewアクションにとぶ（カード登録画面）
      # binding.pry
    else #該当のカード情報がある場合
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #Payjpの秘密鍵(credential.ymlに保存している)
      #Payjpに登録してある顧客情報を秘密鍵でひっぱってくる
      customer = Payjp::Customer.retrieve(card.customer_id) #Payjpの顧客情報が入っている。
      # binding.pry
      @default_card_information = customer.cards.retrieve(card.card_id) #buy.html.hamlに表示させるカード情報を@default_card_informationに入れる
      # binding.pry
  end
end
  #商品購入のため雉野追記
  def pay #支払い
    @items = Item.find(params[:id]) #URLのidとitemテーブルのidが同じ情報を@itemsに入れる。
    card = Card.where(user_id: current_user.id).first #cardテーブルから現在ログインしているユーザーのidを使ってカード情報を取得する
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #payjpの秘密鍵
    # binding.pry
    #支払い内容
    Payjp::Charge.create(
      :amount => @items.price,
      :customer => card.customer_id,
      :currency => 'jpy',
    )
    redirect_to action: 'done' #支払い完了ページに移動する
    # binding.pry
  end
  #商品購入のため雉野追記
  def done #購入完了ページ
  end

  private

  def item_params
    params.require(:item).permit(:trade_name, :description, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price,
    size_attributes: [:id, :size],
    items_categories_atributes: [:item_id, :category_id] , 
    brand_attributes: [:id, :name], 
    photos_attributes: [:id, :url],  #item.rbに記定義したphotos_attributesをここに書くことでparamsで持ってこています。
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end

end