class AddPreviewToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :preview, :string
  end
end
