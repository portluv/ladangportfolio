class CreateExperiences < ActiveRecord::Migration[5.1]
  def change
    create_table :experiences do |t|
      t.references :profile, foreign_key: true
      t.references :firm, foreign_key: true
      t.string :position
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
