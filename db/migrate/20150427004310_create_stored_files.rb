class CreateStoredFiles < ActiveRecord::Migration
  def change
    create_table :stored_files do |t|
      t.string :file
      t.string :file_list
      t.string :format
      t.boolean :compressed

      t.integer :artifact_id

      t.timestamps
    end
  end
end
