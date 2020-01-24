class ItemsController < ApplicationController

  require 'payjp'

  before_action :authenticate_user!, only: [:edit, :update, :destory, :buy, :pay]

  def index

    @items = Item.all.order("created_at DESC").limit(10)

    #人気カテゴリー
    @ladies = Item.where(category_parent: 1).order("created_at DESC").limit(10) #itemテーブルからcategory_parentが1（レディース）のアイテムを取得して@ladiesに渡す
    @mens = Item.where(category_parent: 139).order("created_at DESC").limit(10) #itemテーブルからcategory_parentが139（メンズ）のアイテムを取得して@mensに渡す
    @hobby = Item.where(category_parent: 579).order("created_at DESC").limit(10) #itemテーブルからcategory_parentが579(おもちゃ)のアイテムを取得して@hobyに渡す
    @appliances = Item.where(category_parent: 784).order("created_at DESC").limit(10) #itemテーブルからcategory_parentが784(家電)のアイテムを取得して@home_appliancesに渡す

    #人気ブランド
    @chanel = Item.where(brand: "シャネル").order("created_at DESC").limit(10)
    @louis_vuitton = Item.where(brand: "ルイヴィトン").order("created_at DESC").limit(10)
    @supreme = Item.where(brand: "シュプリーム").order("created_at DESC").limit(10)
    @nike = Item.where(brand: "ナイキ").order("created_at DESC").limit(10)

  end

  
  def ladies
    @ladies = Item.where(category_parent: 1).order("created_at DESC")
  end

  def mens
    @mens = Item.where(category_parent: 139).order("created_at DESC")
  end

  def appliances
    @appliances = Item.where(category_parent: 784).order("created_at DESC")
  end

  def hobby
    @hobby = Item.where(category_parent: 579).order("created_at DESC").limit(10)
  end

  def chanel
    @chanel = Item.where(brand: "シャネル").order("created_at DESC")
  end

  def louis_vuitton
    @louis_vuitton = Item.where(brand: "ルイヴィトン").order("created_at DESC")
  end

  def supreme
    @supreme = Item.where(brand: "シュプリーム").order("created_at DESC")
  end

  def nike
    @nike = Item.where(brand: "ナイキ").order("created_at DESC")
  end


  def new
    @items = Item.new
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
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
    @items = Item.new(item_params)
    if @items.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @items = Item.find(params[:id])
    @shipment_area_data = Prefecture.find_by(id: @items.shipment_area) #@shipment_areaのidで@Prefectureモデルから該当の都道府県を探して@shipment_area_dataに渡す
    @shipment_area_name = @shipment_area_data.name #Prefectureモデルから見つけた都道府県の名前だけを@shipment_area_nameに渡す
    @user = User.find(@items.seller_id) #seller_idと同じidをUserモデルから探して@userに渡す
    @category_parent = Category.find_by(id: @items.category_parent)
    @category_parent_name = @category_parent.name
  end

  def edit
    @items = Item.find(params[:id])
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
  end

  def update 
    @items = Item.find(params[:id]) #もともと登録されていた商品情報(itemモデル分)
    @user = User.find(@items.seller_id)
    if delete_params[:image_id].present? #editからparams[:image_id]が送られてきたら以下の処理を行う
      @delete_params = delete_params[:image_id]
      @active = @items.images.find(@delete_params)
      @active.each do |active|
        active.purge
      end
    end

    if @items.update(item_params) #editで入力した編集情報で@itemを更新する
      redirect_to action: 'show'
    else
      render :edit
    end
  end

  def destroy
    @items = Item.find(params[:id]) #URLのitem_idのデータを取り出して@itemsに渡す
    @user = User.find(@items.seller_id)
    if @items.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  def buy
    @items = Item.find(params[:id]) #URLのidと同じitem_idの情報をitemモデルから取り出して@itemsに入れる。
    #画像表示
    @items_id = @items.id #@itemsのitem_idだけ取り出して@items_idに渡す

    #購入者情報
    @buyer = Address.find_by(user_id: current_user.id) #購入者の配送先住所を取得する
    @buyer_prefecrure = Prefecture.find_by(id: @buyer.prefecture_id) #@buyerのprefecture_idでPrefectureモデルから都道府県のidとnameを引っ張る
    @prefecture_name = @buyer_prefecrure.name #@buyer_prefecuture.nameで都道府県名だけにして@prefecture_nameに渡す
    
    #クレジットカード情報
    card = Card.where(user_id: current_user.id).first #cardテーブルから現在ログインしているユーザーのidのuser_idをcardに入れる id,user_id,customer_id,card_idが入っている。
    if card.blank? #テーブルに登録されたカード情報がなければ
      redirect_to controller: "card", action: "new" #card_controllerのnewアクションにとぶ（カード登録画面）
    else #該当のカード情報がある場合
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #Payjpの秘密鍵(credential.ymlに保存している)

      #Payjpに登録してある顧客情報を秘密鍵でひっぱってくる
      customer = Payjp::Customer.retrieve(card.customer_id) #Payjpの顧客情報が入っている。
      @default_card_information = customer.cards.retrieve(card.card_id) #buy.html.hamlに表示させるカード情報を@default_card_informationに入れる
  end
end

  def pay #支払い
    @items = Item.find(params[:id]) #URLのidとitemテーブルのidが同じ情報を@itemsに入れる。
    card = Card.where(user_id: current_user.id).first #cardテーブルから現在ログインしているユーザーのidを使ってカード情報を取得する
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY] #payjpの秘密鍵

    #支払い内容
    Payjp::Charge.create(
      :amount => @items.price,
      :customer => card.customer_id,
      :currency => 'jpy',
    )
    @items.update(buyer_id: current_user.id) #購入者のuser_idがitemテーブルのbuyer_idに登録される
    redirect_to action: 'done' #支払い完了ページに移動する
  end

  def done #購入完了ページ
  end

  private

  def item_params
    params.require(:item).permit(:trade_name, :description, :size, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price, :category_parent, :category_child, :category_grandchild, :brand, images: [],
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end

  def delete_params
    params.require(:item).permit(:trade_name, :description, :size, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price, :category_parent, :category_child, :category_grandchild, :brand, images: [],image_id:[],
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end

end