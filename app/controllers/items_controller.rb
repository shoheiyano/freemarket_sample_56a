class ItemsController < ApplicationController

  def index
    @items = Item.all.order("created_at DESC")
  end

  def new
    @item = Item.new
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    
    @item_photo = @item.photos.build #子モデルのphotoを保存させるための記述。_buildの書き方でエラーが出ました。コネクトで聞いた結果、同じ意味である左記の記述で書いてあります。
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
  end

  private

  def item_params
    params.require(:item).permit(:trade_name, :description, :condition, :postage, :delivery_method, :shipment_area, :shipment_date, :price,
    size_attributes: [:id, :size],
    items_categories_attributes: [:item_id, :category_id] , 
    brand_attributes: [:id, :name], 
    photos_attributes: [:id, :url],  #item.rbに記定義したphotos_attributesをここに書くことでparamsで持ってこています。
    ).merge(user_id: current_user.id, seller_id: current_user.id)
  end
end