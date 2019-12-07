class AddBirthToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :birth_year, :integer,   null: false
    add_column :addresses, :birth_month, :integer,  null: false
    add_column :addresses, :birth_day, :integer,    null: false
  end
end
