require './lib/file_extractors/zip_extractor'
require './lib/file_extractors/sf2_extractor'
require './lib/file_extractors/null_extractor'

module FileExtractor

  def self.get_extractor file

    case file.file.extension.downcase
    when 'zip'
      FileExtractor::ZipExtractor.new(file.path)
    when 'sf2'
      FileExtractor::SF2Extractor.new(file.path)
    else
      FileExtractor::NullExtractor.new(file.path)
    end

  end

end