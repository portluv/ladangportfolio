class CreateSpecialities < ActiveRecord::Migration[5.1]
  def change
    create_table :specialities do |t|
      t.references :profile, foreign_key: true
      t.string :name
      t.string :position

      t.timestamps
    end
  end
end
