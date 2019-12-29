class ItemsController < ApplicationController

  require 'payjp'

  before_action :authenticate_user!, only: [:edit, :update, :destory, :buy, :pay]

  def index
    @items = Item.all.order("created_at DESC")
  end

  def new
    @item = Item.new
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)

    # @item_photo = @item.photos.build #子モデルのphotoを保存させるための記述。_buildの書き方でエラーが出ました。コネクトで聞いた結果、同じ意味である左記の記述で書いてあります。
    # @item_size = @item.size.build
    @item_size = Size.new #この記述がなくても動作する
    @item_brand = Brand.new #この記述がなくても動作する
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
    # binding.pry
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
    @photo_data = Photo.find_by(item_id: @items.id) #photoモデルから出品アイテムのidと同じitem_idのレコードをひっぱてきて@photo_dateに渡す
    @shipment_area = @items.shipment_area #雉野追記、@itemsにあるshipment_areaのidだけを@shipment_areaに渡す
    @shipment_area_data = Prefecture.find_by(id: @shipment_area) #雉野追記、@shipment_areaのidで@Prefectureモデルから該当の都道府県を探して@shipment_area_dataに渡す
    @shipment_area_name = @shipment_area_data.name #雉野追記、Prefectureモデルから見つけた都道府県の名前だけを@shipment_area_nameに渡す
    @user = User.find(@items.seller_id) #雉野追記、seller_idと同じidをUserモデルから探して@userに渡す
    @category_name = @items.category_parent
    @category_parent = Category.find_by(id: @category_name)
    @category_parent_name = @category_parent.name
  end

  def edit #雉野追記
    @item = Item.find(params[:id])
    @photo_data = Photo.find_by(item_id: @item.id)
    # binding.pry
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    # binding.pry
    # @item_photo = @item.photos.build #いらない
    # binding.pry
  end

  def update #雉野追記
    @items = Item.find(params[:id]) #もともと登録されていた商品情報(itemモデル分)
    # @photo_data = Photo.find_by(item_id: @items.id)

    # @user = User.find(@items.seller_id)
    # binding.pry
    # @item_photo = @item.photos.build #もとも登録されていた商品画像(photoモデル分)
    binding.pry
    if @items.update(item_params) #editで入力した編集情報で@itemを更新する
      # binding.pry
      # flash[:notice] = "商品を更新しました"
      redirect_to action: 'show'
    else
      # flash[:notice] = "商品の更新に失敗しました"
      render :edit
    end
  end

  def destroy #雉野追記
    @items = Item.find(params[:id]) #URLのitem_idのデータを取り出して@itemsに渡す
    @items_photo = @items.photos.build
    @user = User.find(@items.seller_id)
    # binding.pry
    if @items.destroy
      # binding.pry
      # flash[:notice] = "商品を削除しました"
      redirect_to root_path
      # binding.pry
    else
      # flash[:notice] = "商品の削除に失敗しました"
      render :show
      # binding.pry
    end
  end

  #商品購入のため雉野追記
  def buy
    @items = Item.find(params[:id]) #URLのidと同じitem_idの情報をitemモデルから取り出して@itemsに入れる。
    #画像表示
    @items_id = @items.id #@itemsのitem_idだけ取り出して@items_idに渡す
    @photo_data = Photo.find_by(item_id: @items_id) #items_idと同じitem_idの情報をPhotoモデルから取り出して@photo_dataに渡す

    #購入者情報
    @buyer = Address.find_by(user_id: current_user.id) #購入者の配送先住所を取得する
    @buyer_prefecrure = Prefecture.find_by(id: @buyer.prefecture_id) #@buyerのprefecture_idでPrefectureモデルから都道府県のidとnameを引っ張る
    @prefecture_name = @buyer_prefecrure.name #@buyer_prefecuture.nameで都道府県名だけにして@prefecture_nameに渡す
    
    #クレジットカード情報
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
    @items.update(buyer_id: current_user.id) #雉野追記、購入者のuser_idがitemテーブルのbuyer_idに登録される
    redirect_to action: 'done' #支払い完了ページに移動する
    # binding.pry
  end
  #商品購入のため雉野追記
  def done #購入完了ページ
  end

  private

  def item_params
    params.require(:item).permit(:trade_name, :description, :size, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price, :category_parent, :category_child, :category_grandchild, :brand, :image,
    items_categories_attributes: [:item_id, :category_id] , 
    photos_attributes: [:id, :url, :_destroy],  #item.rbに記定義したphotos_attributesをここに書くことでparamsで持ってこています。
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end
end