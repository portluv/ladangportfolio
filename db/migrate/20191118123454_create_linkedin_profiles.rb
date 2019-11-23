class CreateLinkedinProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :linkedin_profiles do |t|
      t.text :access_token
      t.datetime :expire_in
      t.text :profile_url
      t.string :linkedin_profile_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
