class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def new
  end
  

  def show
  end

  def creat
    @item = Item.new
  end

  
    private

    def item_params
      params.require(:item).permit(:name)
    end
end