json.array!(@software) do |tag|
  json.id tag.name
  json.text tag.name
end
