json.array!(@file_formats) do |f|
  json.id f.name
  json.text f.name
end