class AddExtraLicenseTextToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :extra_license_text, :string
  end
end
