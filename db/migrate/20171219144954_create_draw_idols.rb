class CreateDrawIdols < ActiveRecord::Migration[5.1]
  def change
    create_table :draw_idols do |t|
      t.references :user, foreign_key: true
      t.references :idol, foreign_key: true
      t.string :name
      t.string :img_url

      t.timestamps
    end
  end
end
