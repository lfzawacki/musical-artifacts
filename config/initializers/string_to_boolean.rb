class String
  def to_boolean
    ActiveRecord::Type::Boolean.new.type_cast_from_user(self)
  end
end
