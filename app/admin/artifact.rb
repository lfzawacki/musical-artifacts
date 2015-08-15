ActiveAdmin.register Artifact do
  permit_params :name, :approved, :downloadable, :author, :file_hash, :mirrors, :license,
    :more_info_urls, :extra_license_text, :stored_files

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs "Artifact Details" do
      f.input :name
      f.input :approved
      f.input :downloadable
      f.input :author
      f.input :file_hash
      f.input :mirrors
      f.input :license
      f.input :more_info_urls
      f.input :extra_license_text
      f.input :stored_files
    end
    f.actions
  end

end
