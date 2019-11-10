class CreateTradingPartners < ActiveRecord::Migration[5.2]
  def change
    create_table :trading_partners do |t|

      t.timestamps
    end
  end
end
