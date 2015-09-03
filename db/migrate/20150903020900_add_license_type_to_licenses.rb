class AddLicenseTypeToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :license_type, :string
  end
end
