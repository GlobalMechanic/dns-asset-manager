class ReelAssetsClipIdToAssetId < ActiveRecord::Migration
  def change
    rename_column :reel_assets, :clip_id, :asset_id
  end
end
