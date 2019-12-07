class RemoveColumnFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :first_name_kana, :string
    remove_column :users, :last_name_kana, :string
    remove_column :users, :password, :string
    remove_column :users, :password_confirmation, :string
    remove_column :users, :birthday, :date
    remove_column :users, :provider, :string
    remove_column :users, :phone_number, :integer
  end
end
