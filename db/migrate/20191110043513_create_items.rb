class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string            :trade_name, null: false
      t.text              :description, null: false
      t.string            :condition, null: false
      t.string            :postage, null: false
      t.string            :delivery_method, null: false
      t.string            :shipment_area, null: false
      t.string            :shipment_date, null: false
      t.integer           :price, null: false
      t.references        :seller_id, null: false, foreign_key: true
      t.references        :buyer_id
      t.references        :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
