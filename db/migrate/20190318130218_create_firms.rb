class CreateFirms < ActiveRecord::Migration[5.1]
  def change
    create_table :firms do |t|
      t.string :name
      t.string :address
      t.string :profile_picture
      t.string :home_picture
      t.bigint :followers
      t.references :firmtype, foreign_key: true

      t.timestamps
    end
  end
end
