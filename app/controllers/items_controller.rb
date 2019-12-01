class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
    @parents = Category.where(ancestry: nil).order("id ASC").limit(13)
    @item.size
    @item.brand
    @item.photos
  end

  def search
    respond_to do |format|
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
         # 親カテゴリーのidから子カテゴリーのidの配列を作成してインスタンス変数で定義
      end
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save!
      size_id = Size.find(@item.id).id
      brand_id = Brand.find(@item.id).id
      item = Item.find(@item.id)
      item.update(size_id: size_id)
      item.update(brand_id: brand_id)
      redirect_to root_path
    else
      redirect_to new_item_path
    end
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :condition, :postage, :delivery_method, :prefecture_id, :shipment_date, :price, size_attributes: [:id, :size], brand_attributes: [:id, :name], photo_attributes: [:id, :url], category_ids: []).merge(seller_id: current_user.id)
  end

end