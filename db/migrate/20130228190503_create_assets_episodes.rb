class CreateAssetsEpisodes < ActiveRecord::Migration
  def change
    add_column :assets, :episode_id, :integer
  end
end
