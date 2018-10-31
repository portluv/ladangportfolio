class CreateStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.text :status
      t.references :thing, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
