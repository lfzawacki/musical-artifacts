ActiveAdmin.register Artifact do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    # column :current_sign_in_at
    # column :sign_in_count
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs "Artifact Details" do
      f.input :name
    end
    f.actions
  end

end
