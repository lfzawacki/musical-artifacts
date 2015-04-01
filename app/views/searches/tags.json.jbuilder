json.array!(@tags) do |tag|
  json.name tag.name
  json.term tag.name
end
