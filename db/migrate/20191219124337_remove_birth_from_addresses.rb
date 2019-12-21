class RemoveBirthFromAddresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :birth_year, :integer
    remove_column :addresses, :birth_month, :integer
    remove_column :addresses, :birth_day, :integer
  end
end
