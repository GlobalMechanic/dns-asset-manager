class RemovePaperclipThumbnail < ActiveRecord::Migration
  def change
    remove_column :clips, :thumbnail_file_name
    remove_column :clips, :thumbnail_content_type
    remove_column :clips, :thumbnail_file_size
    remove_column :clips, :thumbnail_updated_at
  end
end
