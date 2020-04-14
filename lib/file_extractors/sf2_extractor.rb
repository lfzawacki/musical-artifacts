module FileExtractor

  class SF2Extractor

    def initialize file
      @file = file
    end

    def file_list
      list = []

      begin
        escape_characters = /([\/])/
        content = IO.popen("sf2text \"#{@file}\"").read

        # Search for the pattern for a sounfont preset, like this:
        # (0 "Acoustic Bass" (preset 0) (bank 0)
        matches = content.scan(/\([0-9]+ "?([^"]*)"? \(preset ([0-9]+)\) \(bank ([0-9]+)\)/)

        matches.each do |preset|
          preset_name = "#{sprintf "%03d", preset[2]}-#{sprintf "%03d", preset[1]} #{preset[0].gsub(escape_characters, "\\\1")}"

          if preset[0] != 'EOP'
            list.unshift(preset_name)
          end
        end

        if content.blank? # probably sf2text is not present
          Rails.logger.error("[sf2 error] File: #{@file}. sf2text missing or weird file.")
        end
      end

      list.sort
    end

    def get_data
      {}
    end

    def null?
      false
    end

  end

end
