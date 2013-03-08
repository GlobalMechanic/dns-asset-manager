class AddSwfPreviewToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :preview_swf, :string
  end
end
