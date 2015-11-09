class StoredFileObserver < ActiveRecord::Observer

  def after_create(stored_file)
    stored_file.fetch_metadata_from_file
  end

end