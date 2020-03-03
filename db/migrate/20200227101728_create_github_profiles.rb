class CreateGithubProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :github_profiles do |t|
      t.text :access_token
      t.text :profile_url
      t.string :github_profile_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
