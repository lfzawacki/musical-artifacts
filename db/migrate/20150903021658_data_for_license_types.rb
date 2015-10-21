class DataForLicenseTypes < ActiveRecord::Migration
  def up
    ['by', 'by-sa', 'by-nd', 'by-nc', 'by-nc-sa', 'by-nc-nd', 'cc-sample'].each do |l|
      License.where(short_name: l).try(:update_attributes, license_type: 'cc')
    end

    License.where(short_name: 'public').try(:update_attributes, license_type: 'public')
    License.where(short_name: 'copyright').try(:update_attributes, license_type: 'copyright')

    ['gpl', 'gpl-v2', 'gpl-v3', 'copyleft'].each do |l|
      License.where(short_name: l).try(:update_attributes, license_type: 'gpl')
    end
  end

  def down
    # do nothing, when rolling back the next migration erases the column
  end
end
