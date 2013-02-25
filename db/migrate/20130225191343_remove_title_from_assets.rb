class RemoveTitleFromAssets < ActiveRecord::Migration
  def up
    remove_column :assets, :title
  end

  def down
    add_column :assets, :title, :string
  end
end
