class AddDetailsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :category_parent, :string
    add_column :items, :category_child, :string
    add_column :items, :category_grandchild, :string
    add_column :items, :size, :string
  end
end
