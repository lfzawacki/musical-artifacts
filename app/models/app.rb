class App < ActiveRecord::Base
  acts_as_taggable_on :file_formats, :software

end
