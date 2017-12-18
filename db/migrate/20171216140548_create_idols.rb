class CreateIdols < ActiveRecord::Migration[5.1]
  def change
    create_table :idols do |t|
      t.string :name
      t.string :img_url
      t.integer :max_issuance

      t.timestamps
    end
  end
end
