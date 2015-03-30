json.array!(@artifacts) do |artifact|
  json.extract! artifact, :name, :description, :author, :archive_url, :file_hash
  json.file artifact.file.url
  json.license artifact.license.short_name
  json.url artifact_url(artifact, format: :json)
end
