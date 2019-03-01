class AddHomePictureToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :home_picture, :string
  end
end
