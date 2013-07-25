class AddCacheColumnToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :cached_keyword_list, :string, :limit => 500
    add_column :assets, :cached_name_list, :string

    Asset.reset_column_information
    # next line makes ActsAsTaggableOn see the new column and create cache methods
    ActsAsTaggableOn::Taggable::Cache.included(Asset)
    Asset.find_each(:batch_size => 1000) do |p|
      p.keyword_list # it seems you need to do this first to generate the list
      p.name_list # it seems you need to do this first to generate the list
      p.save! # you were missing the save line!
    end
  end
end
