class CreateThings < ActiveRecord::Migration[5.1]
  def change
    create_table :things do |t|
      t.string :name
      t.string :path
      t.bigint :thingtype_id
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_foreign_key :things, :thingtypes, column: :thingtype_id
  end
end
