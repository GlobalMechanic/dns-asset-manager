class CreateAssetsScenesTable < ActiveRecord::Migration
  def up
    create_table :assets_scenes, :id => false do |t|
      t.integer :asset_id
      t.integer :scene_id
    end
    remove_column :assets, :scene_id
  end

  def down
    drop_table :assets_scenes
    add_column :assets, :scene_id, :integer
  end
end
