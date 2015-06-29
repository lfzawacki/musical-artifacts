ActiveAdmin.register App do
  permit_params :name, :description

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
    f.inputs "App Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end

end
