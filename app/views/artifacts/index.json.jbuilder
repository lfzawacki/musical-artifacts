json.array!(@artifacts) do |artifact|
  json.extract! artifact, :name, :description, :author, :file_hash
  json.file artifact.download_path
  json.license artifact.license.short_name
  json.url artifact_url(artifact, format: :json)
end
