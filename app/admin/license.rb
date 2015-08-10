ActiveAdmin.register License do
  permit_params :name, :short_name

  index do
    selectable_column
    id_column
    column :name
    column :short_name
    column :created_at
    actions
  end

  filter :name
  filter :short_name
  filter :created_at

  form do |f|
    f.inputs "License Details" do
      f.input :name
      f.input :short_name
    end
    f.actions
  end

end
