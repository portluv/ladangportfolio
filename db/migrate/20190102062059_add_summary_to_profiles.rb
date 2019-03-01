class AddSummaryToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :summary, :text
  end
end
