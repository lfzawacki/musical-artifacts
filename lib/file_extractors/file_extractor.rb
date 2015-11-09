require './lib/file_extractors/zip_extractor'
require './lib/file_extractors/null_extractor'

module FileExtractor

  def self.get_extractor file

    case file.file.extension.downcase
    when 'zip'
      FileExtractor::ZipExtractor.new(file.path)
    else
      FileExtractor::NullExtractor.new(file.path)
    end

  end

end