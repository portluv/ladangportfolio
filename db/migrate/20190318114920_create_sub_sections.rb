class CreateSubSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_sections do |t|
      t.references :section, foreign_key: true
      t.string :title
      t.string :data
      t.string :logo

      t.timestamps
    end
  end
end
