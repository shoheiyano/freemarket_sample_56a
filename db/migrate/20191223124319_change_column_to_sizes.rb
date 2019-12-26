class ChangeColumnToSizes < ActiveRecord::Migration[5.2]
  def up
    change_column :sizes, :size_id, :bigint, nill: false
  end

  def down
    change_column :sizes, :size_id, :string, null: false
  end
end
