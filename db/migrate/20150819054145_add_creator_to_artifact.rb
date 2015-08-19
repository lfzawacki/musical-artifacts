class AddCreatorToArtifact < ActiveRecord::Migration
  def change
    add_column :artifacts, :user_id, :integer
  end
end
