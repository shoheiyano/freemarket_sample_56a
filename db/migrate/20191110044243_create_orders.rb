class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string      :status, null: false
      t.references  :item_id, null: false, foreign_key: true
      t.references  :trading_partner_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
