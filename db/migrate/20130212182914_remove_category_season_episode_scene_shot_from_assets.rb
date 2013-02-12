class RemoveCategorySeasonEpisodeSceneShotFromAssets < ActiveRecord::Migration
  def up
    remove_column :assets, :category
    remove_column :assets, :season
    remove_column :assets, :episode
    remove_column :assets, :scene
    remove_column :assets, :shot
  end

  def down
    add_column :assets, :category, :string
    add_column :assets, :season, :integer
    add_column :assets, :episode, :integer
    add_column :assets, :scene, :integer
    add_column :assets, :shot, :integer
  end
end
