class AddTitleToAsset < ActiveRecord::Migration
  def up
    add_column :assets, :title, :string
    Asset.all.each { |asset| asset.save! }
  end

  def down
    remove_column :assets, :title
  end
end
