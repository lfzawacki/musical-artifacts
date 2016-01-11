require 'zip'

# Overwrite existing files when extracting
# We'll extract them to tmp anyways
Zip.on_exists_proc = true

module FileExtractor

  class ZipExtractor

    def initialize file
      @file = file
    end

    def file_list
      list = []

      begin
        zip_file = Zip::File.open(@file)
        # This is a source of external strings which are shown in the interface
        # so I'll just convert it to UTF-8 here to prevent problems
        list += zip_file.map do |file|
          file.name.force_encoding("UTF-8")
        end

        # Try to get the contents of each of the present files
        zip_file.glob('*').each do |entry|
          name = File.join("/tmp/", entry.name)
          extension = File.extname(name)[1..-1]

          xt = FileExtractor.get_extractor(name, extension)

          # Only do the temp zip extracting if extractor is not nil
          unless xt.null?
            entry.extract(name)
            files = xt.file_list
            list += files.map{ |f| "#{entry.name}/#{f}" }

            FileUtils.rm(name, :force => true)
          end
        end

      rescue Zip::Error => e
        Rails.logger.error("[zip error] #{e.message}")
      end

      list
    end

    def null?
      false
    end

    def get_data
      {}
    end

  end

end