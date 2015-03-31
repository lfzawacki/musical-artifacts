json.extract! @artifact, :name, :description, :author, :file_hash
json.license @artifact.license.short_name
json.file @artifact.file.url