class MigrateArtifactFilesToFiles < ActiveRecord::Migration
  def up
    Artifact.where.not(file: nil).find_each do |artifact|
      file = StoredFile.new(artifact: artifact, compressed: artifact.compressed, format: artifact.file_format)
      file.file = File.new(File.join(Rails.root, '/public' + artifact.file.url))
      file.save!
    end
  end

  def down
  end
end
