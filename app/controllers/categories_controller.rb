class CategoriesController < ApplicationController

  def index
    @parents = Category.all.order("id ASC")
  end

end
