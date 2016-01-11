module FileExtractor

  class NullExtractor

    def initialize file
    end

    def file_list
      []
    end

    def get_data
      {}
    end

    def null?
      true
    end
  end

end