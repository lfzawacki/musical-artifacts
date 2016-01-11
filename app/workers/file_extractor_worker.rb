class FileExtractorWorker
  @queue = :medium

  def self.perform(stored_file_id)
    f = StoredFile.find(stored_file_id)

    Resque.logger.info(" * [FileExtractor] Extracting metadata from '#{f.file}'")
    f.fetch_metadata_from_file
  end
end