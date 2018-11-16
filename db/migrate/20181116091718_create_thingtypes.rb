class CreateThingtypes < ActiveRecord::Migration[5.1]
  def change
    create_table :thingtypes do |t|
      t.string :typename

      t.timestamps
    end
  end
end
