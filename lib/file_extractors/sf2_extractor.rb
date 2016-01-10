module FileExtractor

  class SF2Extractor

    def initialize file
      @file = file
    end

    def file_list
      list = []

      begin
        content = IO.popen("sf2text #{@file}").read

        # Search for the pattern for a sounfont preset, like this:
        # (0 "Acoustic Bass" (preset 0) (bank 0)
        matches = content.scan(/\(([0-9]+) "?([^"]*)"? \(preset [0-9]+\) \(bank ([0-9]+)/)

        matches.each do |preset|
          list << "Bank #{preset[2]}/#{preset[0]} - #{preset[1]}"
        end

        if content.blank? # probably sf2text is not present
          Rails.logger.error("[sf2 error] File: #{@file}. sf2text missing or weird file.")
        end
      end

      list
    end

    def get_data
      {}
    end

  end

end