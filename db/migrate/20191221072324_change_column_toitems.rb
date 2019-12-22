class ChangeColumnToitems < ActiveRecord::Migration[5.2]

  def up
    change_column :items, :condition, :integer, null: false
  end

  def down
    change_column :items, :condition, :string, null: false
  end
end