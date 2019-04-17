class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.references :profile, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
