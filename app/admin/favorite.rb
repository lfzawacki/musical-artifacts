ActiveAdmin.register Favorite do
  permit_params :artifact, :user

  index do
    selectable_column
    id_column
    column :artifact
    column :user
  end

  filter :artifact
  filter :compressed

  form do |f|
    f.inputs "File Details" do
      f.input :artifact
      f.input :user
    end
    f.actions
  end

end
