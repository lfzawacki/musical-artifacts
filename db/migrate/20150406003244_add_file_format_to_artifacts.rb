class AddFileFormatToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :file_format, :string
  end
end
