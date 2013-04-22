class ChangeAssetTypeClipsToAnimatic < ActiveRecord::Migration
  def up
    Asset.update_all({ :asset_type => 'animatic' }, { :asset_type => 'clips' })
  end

  def down
    Asset.update_all({ :asset_type => 'clips' }, { :asset_type => 'animatic' })
  end
end
