class AddDefaultValueToAssetType < ActiveRecord::Migration
  def up
     change_column :assets, :asset_type, :string, :default => 'character', :null => false
  end
  def down
    change_column :assets, :asset_type, :string
  end
end
