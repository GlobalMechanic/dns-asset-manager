class AddStatusSubmittedCheckedOutUserIdToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :status, :string, :default => 'setup', :null => false
    add_column :assets, :submitted, :boolean
    add_column :assets, :checked_out, :boolean
    add_column :assets, :user_id, :integer
  end
end
