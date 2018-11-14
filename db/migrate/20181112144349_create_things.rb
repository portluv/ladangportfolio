class CreateThings < ActiveRecord::Migration[5.1]
  def change
    create_table :things do |t|
      t.string :name
      t.string :path
      t.integer :thingtype
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
