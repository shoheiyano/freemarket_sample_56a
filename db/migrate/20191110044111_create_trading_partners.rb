class CreateTradingPartners < ActiveRecord::Migration[5.2]
  def change
    create_table :trading_partners do |t|
      t.references    :seller_id, null: false, foreign_key: {to_table: :users}
      t.references    :buyer_id, null: false, foreign_key: {to_table: :users}	

      t.timestamps
    end
  end
end
