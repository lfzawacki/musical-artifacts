require 'zip'

module FileExtractor

  class ZipExtractor

    def initialize file
      @file = file
    end

    def file_list
      list = []

      begin
        list = Zip::File.open(@file) do |zip_file|
          # This is a source of external strings which are shown in the interface
          # so I'll just convert it to UTF-8 here to prevent problems
          zip_file.map do |file|
            file.name.force_encoding("UTF-8")
          end
        end

      rescue Zip::Error => e
        Rails.logger.error("[zip error] #{e.message}")
      end

      list
    end

    def get_data
      {}
    end

  end

end