class AddColumnToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :postal_cord, :integer,          null: false
    add_column :addresses, :prefecture, :string,            null: false
    add_column :addresses, :block, :string,                 null: false
    add_column :addresses, :building, :string
    add_column :addresses, :phone_number, :integer
    add_reference :addresses, :user_id, foreign_key: true,  null: false
  end
end
