json.extract! @artifact, :name, :description, :author, :archive_url, :file_hash
json.license @artifact.license.short_name
json.file @artifact.file.url