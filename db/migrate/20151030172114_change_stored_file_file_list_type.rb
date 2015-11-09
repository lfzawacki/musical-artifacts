class ChangeStoredFileFileListType < ActiveRecord::Migration
  def up
    change_column :stored_files, :file_list, :text
  end

  def down
    change_column :stored_files, :file_list, :string
  end
end
