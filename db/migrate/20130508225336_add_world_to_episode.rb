class AddWorldToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :world, :string
  end
end
