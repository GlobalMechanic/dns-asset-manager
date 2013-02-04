class RemoveClipFields < ActiveRecord::Migration
  def up
     remove_column :assets, :video
     remove_column :assets, :image
     remove_column :assets, :director
     remove_column :assets, :agency
     remove_column :assets, :client
     remove_column :assets, :year
     remove_column :assets, :month
     remove_column :assets, :active
     remove_column :assets, :legacy_id
  end
 
  def down
    add_column :assets, :video, :string
    add_column :assets, :image, :string
    add_column :assets, :director, :string
    add_column :assets, :agency, :string
    add_column :assets, :client, :string
    add_column :assets, :year, :string
    add_column :assets, :month, :string
    add_column :assets, :active, :boolean
    add_column :assets, :legacy_id, :integer
  end
end
