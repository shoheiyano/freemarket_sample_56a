class RenameSizeIdColumnToSizes < ActiveRecord::Migration[5.2]
  def change
    rename_column :sizes, :size_id, :item_id
  end
end
