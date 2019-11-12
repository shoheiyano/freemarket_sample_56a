class ItemsController < ApplicationController
  def index
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