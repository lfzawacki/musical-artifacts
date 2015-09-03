ActiveAdmin.register License do
  permit_params :name, :short_name, :license_type

  index do
    selectable_column
    id_column
    column :name
    column :short_name
    column :license_type
    column :created_at
    actions
  end

  filter :name
  filter :short_name
  filter :license_type
  filter :created_at

  form do |f|
    f.inputs "License Details" do
      f.input :name
      f.input :short_name
      f.input :license_type
    end
    f.actions
  end

end
