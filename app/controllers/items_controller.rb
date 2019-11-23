class ItemsController < ApplicationController
  def index
    @item = Item.all
  end

  def new
  end
  

  def show
    
  end


  
    private

    def item_params
      params.require(:item).permit(:name)
    end
end