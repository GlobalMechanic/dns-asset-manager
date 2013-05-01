class AddRevisionApprovedToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :approved, :boolean
    add_column :assets, :revision, :boolean
  end
end
