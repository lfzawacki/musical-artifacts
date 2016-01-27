class BackfillActivities < ActiveRecord::Migration
  def up
    Artifact.find_each do |artifact|
      act = artifact.create_activity :create
      act.update_column :created_at, artifact.created_at
    end
  end

  def down
    PublicActivity::Activity.where(key: 'artifact.create').delete_all
  end
end