class AddAssetToClips < ActiveRecord::Migration
  def change
    add_column :clips, :asset, :string
  end
end
