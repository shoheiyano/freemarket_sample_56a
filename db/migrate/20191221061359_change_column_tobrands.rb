class ChangeColumnTobrands < ActiveRecord::Migration[5.2]


  def up
    change_column :brands, :name, :string , null: true
  end

  def down
    change_column :brands, :name, :string, null: false
  end

end
