class AddReuseFlagToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :reuse, :boolean
  end
end
