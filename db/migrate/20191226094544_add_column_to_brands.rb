class AddColumnToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :item_id, :string
  end
end
