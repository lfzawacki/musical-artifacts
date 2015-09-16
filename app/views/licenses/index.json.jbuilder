json.array!(@licenses) do |license|
  json.extract! license, :id, :name, :short_name, :license_type
end
