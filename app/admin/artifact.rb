ActiveAdmin.register Artifact do
  permit_params :name, :approved, :downloadable, :author, :user, :mirrors, :license,
    :more_info_urls, :extra_license_text, :stored_files, :user, :user_id

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :tag_list
    column :software_list
    column :file_format_list
    column :created_at
    column :approved
    column :downloadable
    actions
  end

  filter :name
  filter :created_at
  filter :approved
  filter :downloadable
  filter :user
  filter :favorite_count
  filter :download_count

  form do |f|
    f.inputs "Artifact Details" do
      f.input :name
      f.input :user
      f.input :approved
      f.input :downloadable
      f.input :author
      f.input :mirrors, input_html: { value: f.artifact.mirrors.try(:join, ',') }
      f.input :more_info_urls, input_html: { value: f.artifact.more_info_urls.try(:join, ',') }
      f.input :license
      f.input :extra_license_text, as: :text
      f.input :stored_files
    end
    f.actions
  end

end
