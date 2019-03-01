class CreateStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.text :status
      t.string :photo
      t.integer :status_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
