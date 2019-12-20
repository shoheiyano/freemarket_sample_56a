class AddColumnsSecondToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_name, :string,       null: false
    add_column :users, :first_name, :string,      null: false
    add_column :users, :last_name_kana, :string,  null: false
    add_column :users, :first_name_kana, :string, null: false
    add_column :users, :birth_year, :integer,     null: false
    add_column :users, :birth_month, :integer,    null: false
    add_column :users, :birth_day, :integer,      null: false
    add_column :users, :phone_number, :string,    null: false
  end
end
