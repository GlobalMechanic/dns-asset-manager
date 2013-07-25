class AddAssetIndexes < ActiveRecord::Migration
  def change
    add_index :assets_scenes, :asset_id
    add_index :assets_scenes, :scene_id
    add_index :reel_assets, :reel_id
    add_index :reel_assets, :asset_id
    add_index :scenes, :episode_id
  end
end
