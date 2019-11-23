class AddConfirmedProfilesToLinkedinProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :linkedin_profiles, :confirmed_profiles, :boolean, :default => false
  end
end
