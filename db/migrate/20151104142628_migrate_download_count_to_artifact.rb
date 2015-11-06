class MigrateDownloadCountToArtifact < ActiveRecord::Migration
  def up
    StoredFile.where('download_count > 0').each do |file|
      art = file.artifact
      if art.present?
        art.update_attributes(download_count: art.download_count + file.download_count)
      end
    end
  end

  def down
    # No use going back
  end
end
