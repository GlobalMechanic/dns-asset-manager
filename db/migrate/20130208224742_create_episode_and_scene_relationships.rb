class CreateEpisodeAndSceneRelationships < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.integer :number
      t.integer :season
    end

    create_table :scenes do |t|
      t.integer :number
      t.integer :episode_id
    end

    add_column :assets, :scene_id, :integer
  end

  def up
  end

  def down
  end
end
