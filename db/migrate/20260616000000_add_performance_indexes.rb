class AddPerformanceIndexes < ActiveRecord::Migration
  def change
    add_index :favorites, [:artifact_id, :user_id], name: "index_favorites_on_artifact_id_and_user_id"
    add_index :artifacts, :user_id, name: "index_artifacts_on_user_id"
    add_index :stored_files, :artifact_id, name: "index_stored_files_on_artifact_id"
  end
end
