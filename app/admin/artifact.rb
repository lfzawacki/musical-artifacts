ActiveAdmin.register Artifact do
  permit_params :name, :approved, :downloadable, :author, :user, :file_hash, :mirrors, :license,
    :more_info_urls, :extra_license_text, :stored_files, :tag_list, :software_list, :file_format_list

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :tag_list
    column :software_list
    column :file_format_list
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs "Artifact Details" do
      f.input :name
      f.input :user
      f.input :approved
      f.input :downloadable
      f.input :author
      f.input :file_hash
      f.input :mirrors, input_html: { value: f.artifact.mirrors.join(',') }
      f.input :more_info_urls, input_html: { value: f.artifact.more_info_urls.join(',') }
      f.input :license
      f.input :extra_license_text, as: :text
      f.input :stored_files
      f.input :tag_list, input_html: { value: f.artifact.tag_list.join(',') }
      f.input :software_list, input_html: { value: f.artifact.software_list.join(',') }
      f.input :file_format_list, input_html: { value: f.artifact.file_format_list.join(',') }
    end
    f.actions
  end

end
