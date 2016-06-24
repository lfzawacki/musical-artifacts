ActiveAdmin.register App do
  permit_params :name, :description, :url, :has_integration, :software_list, :file_format_list

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :has_integration
    column :software_list
    column :file_format_list
    actions
  end

  filter :name
  filter :created_at
  filter :has_integration

  form do |f|
    f.inputs "App Details" do
      f.input :name
      f.input :description
      f.input :url
      f.input :software_list, input_html: { value: f.app.software_list.try(:join, ',') }
      f.input :file_format_list, input_html: { value: f.app.file_format_list.try(:join, ',') }
      f.input :has_integration
    end
    f.actions
  end

end
