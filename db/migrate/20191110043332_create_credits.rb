class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits do |t|
      t.integer       :card_number, null: false
      t.integer       :expiration_month, null: false
      t.integer       :expiration_year, null: false
      t.integer       :security_cord, null: false
      t.references    :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
