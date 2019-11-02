class ItemsController < ApplicationController
  def index
  end
  

  def show
    @item = Item.new
    @item.save
  end
  
    private

    def item_params
      params.require(:item).permit(:name)
    end
end