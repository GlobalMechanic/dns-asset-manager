class AddPartToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :part, :string
  end
end
