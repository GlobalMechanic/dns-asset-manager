class ClipToAsset < ActiveRecord::Migration
  def change
    rename_table :clips, :assets
    rename_table :reel_clips, :reel_assets
  end
end
