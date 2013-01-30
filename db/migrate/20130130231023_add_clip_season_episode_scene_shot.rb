class AddClipSeasonEpisodeSceneShot < ActiveRecord::Migration
  def change
    add_column :clips, :season, :integer
    add_column :clips, :episode, :integer
    add_column :clips, :scene, :integer
    add_column :clips, :shot, :integer
  end
end
