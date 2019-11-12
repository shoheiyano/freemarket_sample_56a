class ChangeColumnToAddresses < ActiveRecord::Migration[5.2]

  #変更内容
  def up
    change_column :addresses, :city, :string, null: false
  end

  #変更前
  def down
    change_column :addresses, :city, :string
  end
  
end