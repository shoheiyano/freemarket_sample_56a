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
    # @category_parent = @items[0]['category_parent'] #@itemsのcategory_parentの配列から特定の順番の要素を取り出す時の書き方、見直したいので残します

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

    # @item_photo = @item.photos.build #子モデルのphotoを保存させるための記述。_buildの書き方でエラーが出ました。コネクトで聞いた結果、同じ意味である左記の記述で書いてあります。
    # @item_size = @item.size.build
    # @item_size = Size.new #この記述がなくても動作する
    # @item_brand = Brand.new #この記述がなくても動作する
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
    @items = Item.new(item_params)
    if @items.save
      # binding.pry
      redirect_to root_path
    # if @item.save!
    #   size_id = Size.find(@item.id).id
    #   brand_id = Brand.find(@item.id).id
    #   item = Item.find(@item.id)
    #   item.update(size_id: size_id)
    #   item.update(brand_id: brand_id)
    #   redirect_to root_path
    else
      render :new #redirect_to new_item_pathだとエラーは出ませんが...
    end
  end

  def show
    @items = Item.find(params[:id])
    # @shipment_area = @items.shipment_area #雉野追記、@下の記述に含めたので後で消します。
    @shipment_area_data = Prefecture.find_by(id: @items.shipment_area) #雉野追記、@shipment_areaのidで@Prefectureモデルから該当の都道府県を探して@shipment_area_dataに渡す
    @shipment_area_name = @shipment_area_data.name #雉野追記、Prefectureモデルから見つけた都道府県の名前だけを@shipment_area_nameに渡す
    @user = User.find(@items.seller_id) #雉野追記、seller_idと同じidをUserモデルから探して@userに渡す
    # @category_name = @items.category_parent #下の記述に含めたので後で消します。
    @category_parent = Category.find_by(id: @items.category_parent)
    @category_parent_name = @category_parent.name
    # binding.pry
  end

  def edit #雉野追記
    @items = Item.find(params[:id])

    # @active = ActiveStorage::Attachment.where(record_id: @items.id) #activestorage_attachmentテーブルからrecord_idと@items.idが同じ番号のレコードをひっぱてくる
    # @active_id = @active.ids #editに表示する分のattachmentテーブルのidを取得して@active_idに渡す
    # binding.pry
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    # binding.pry
    # @item_photo = @item.photos.build #いらない
    # binding.pry

    # 1/7 一旦コメントアウト
    # # 親セレクトボックスの初期値(配列)
    # @category_parent_array = []
    # # categoriesテーブルから親カテゴリーのみを抽出、配列に格納
    # Category.where(ancestry: nil).each do |parent|
    #   @category_parent_array << parent.name
    # end

    # # itemに紐づいている孫カテゴリーの親である子カテゴリーが属している子カテゴリーの一覧を配列で取得
    # @category_child_array = @item.category.parent.parent.children

    # # itemに紐づいている孫カテゴリーが属している孫カテゴリーの一覧を配列で取得
    # @category_grandchild_array = @item.category.parent.children
  end

  def update #雉野追記
    @items = Item.find(params[:id]) #もともと登録されていた商品情報(itemモデル分)
    # @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    @user = User.find(@items.seller_id)
    # binding.pry
    @items.images.purge #一旦、すべてのimageの紐つけを解除 detachだとblobsにはデータが残り、attachments(中間テーブル)は消える 一方、purgeだとattachments・blobsの両テーブルからデータが消える
    # binding.pry
    if @items.update(item_params) #editで入力した編集情報で@itemを更新する
      # binding.pry
      redirect_to action: 'show'
      # render :show #発送現地域だけ表示されない、別のページに移動すると表示される
      # binding.pry
    else
      render :edit
    end
  end

  def destroy #雉野追記
    @items = Item.find(params[:id]) #URLのitem_idのデータを取り出して@itemsに渡す
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
    params.require(:item).permit(:trade_name, :description, :size, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price, :category_parent, :category_child, :category_grandchild, :brand, images: [],
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end

end

# premit(category_ids: [])