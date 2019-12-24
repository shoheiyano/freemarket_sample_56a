class ChangeDataConditionToItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :condition, :string
  end
end
