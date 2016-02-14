ActiveAdmin.register License do
  permit_params :name, :short_name, :license_type, :free

  index do
    selectable_column
    id_column
    column :name
    column :short_name
    column :license_type
    column :created_at
    column :free
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
      f.input :free
    end
    f.actions
  end

end
