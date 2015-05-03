json.extract! @artifact, :name, :description, :author, :file_hash
json.related @artifact.related.pluck(:id)
json.license @artifact.license.short_name
json.file @artifact.file.try(:url)