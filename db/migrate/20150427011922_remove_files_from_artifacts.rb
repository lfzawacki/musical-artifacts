class RemoveFilesFromArtifacts < ActiveRecord::Migration
  def change
    remove_column :artifacts, :file, :string
    remove_column :artifacts, :file_list, :string
    remove_column :artifacts, :compressed, :boolean
    remove_column :artifacts, :file_format, :string
  end
end
