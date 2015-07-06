# Some extra method definitions
class Hash
  def remove_nesting!
    self.clone.each do |k,v|
      if v.kind_of?(Hash)
        v.each do |k2, v2|
          self["#{k}_#{k2}"] = v2
        end
        self.delete(k)
      end
    end
    self
  end
end