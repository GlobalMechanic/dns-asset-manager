class MoveDesignTypeToRoughs < ActiveRecord::Migration
  def up
    Asset.update_all({ :asset_type => 'roughs' }, { :asset_type => 'design' })
  end

  def down
    Asset.update_all({ :asset_type => 'design' }, { :asset_type => 'roughs' })
  end
end
