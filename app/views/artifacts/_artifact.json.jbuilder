json.extract! @artifact, :id, :name, :description, :author, :file_hash
json.related @artifact.related.pluck(:id)
json.license @artifact.license.short_name
json.tags @artifact.tag_list
json.apps @artifact.software_list
json.formats @artifact.file_format_list
json.mirrors @artifact.mirrors
json.more_info @artifact.more_info_urls
json.license @artifact.license.short_name

if @artifact.file.present?
  json.download_count @artifact.download_count
  json.file @artifact.download_path
end