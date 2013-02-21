class AddStockToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :stock, :boolean
  end
end
