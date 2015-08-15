ActiveAdmin.register StoredFile do
  permit_params :file_list, :format, :compressed, :artifact

  index do
    selectable_column
    id_column
    column :file
    column :format
    column :compressed
    column :artifact
    actions
  end

  filter :file
  filter :format
  filter :compressed

  form do |f|
    f.inputs "File Details" do
      f.input :file
      f.input :file_list
      f.input :format
      f.input :compressed
      f.input :artifact
    end
    f.actions
  end

end
