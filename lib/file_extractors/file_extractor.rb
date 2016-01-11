require './lib/file_extractors/zip_extractor'
require './lib/file_extractors/sf2_extractor'
require './lib/file_extractors/null_extractor'

module FileExtractor

  def self.get_extractor path, extension

    case extension
    when 'zip'
      FileExtractor::ZipExtractor.new(path)
    when 'sf2'
      FileExtractor::SF2Extractor.new(path)
    else
      FileExtractor::NullExtractor.new(path)
    end

  end

end