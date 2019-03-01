class CreateSectionDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :section_details do |t|
      t.string :detail_title
      t.string :detail_description
      t.references :section_header, foreign_key: true

      t.timestamps
    end
  end
end
