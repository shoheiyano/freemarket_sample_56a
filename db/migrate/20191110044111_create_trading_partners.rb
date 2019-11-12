class CreateTradingPartners < ActiveRecord::Migration[5.2]
  def change
    create_table :trading_partners do |t|
      t.references    :seller, null: false, foreign_key: { to_table: :users }
      t.references    :buyer, null: false, foreign_key: { to_table: :users }	

      t.timestamps
    end
  end
end
