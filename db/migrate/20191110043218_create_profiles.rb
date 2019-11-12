class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string      :image
      t.text        :introduction_essay
      t.references  :user_id, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
