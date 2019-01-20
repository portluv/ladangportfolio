class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :fullname
      t.datetime :dateofbirth
      t.string :gender
      t.string :phone
      t.string :address
      t.string :nationality
      t.string :degree
      t.text :lifemotto
      t.string :profile_picture
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
