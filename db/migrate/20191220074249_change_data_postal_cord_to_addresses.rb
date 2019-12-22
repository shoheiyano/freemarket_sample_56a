class ChangeDataPostalCordToAddresses < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :postal_cord, :string
  end
end
