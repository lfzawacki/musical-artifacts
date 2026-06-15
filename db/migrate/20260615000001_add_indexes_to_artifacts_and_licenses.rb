class AddIndexesToArtifactsAndLicenses < ActiveRecord::Migration
  def change
    add_index :artifacts, :approved
    add_index :licenses, :free
  end
end
