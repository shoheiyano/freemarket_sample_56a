class AddColumnToSizes < ActiveRecord::Migration[5.2]
  def change
    add_column :sizes, :size_id, :string, null: false
  end
end
