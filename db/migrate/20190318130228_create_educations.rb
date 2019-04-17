class CreateEducations < ActiveRecord::Migration[5.1]
  def change
    create_table :educations do |t|
      t.references :profile, foreign_key: true
      t.references :firm, foreign_key: true
      t.string :degree
      t.date :join_date
      t.date :end_date

      t.timestamps
    end
  end
end
