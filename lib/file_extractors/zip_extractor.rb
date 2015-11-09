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
          zip_file.map(&:name)
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