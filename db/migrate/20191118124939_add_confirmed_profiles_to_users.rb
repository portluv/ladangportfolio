class AddConfirmedProfilesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :confirmed_profiles, :boolean, :default => false
  end
end
