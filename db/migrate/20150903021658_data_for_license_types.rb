class DataForLicenseTypes < ActiveRecord::Migration
  def up
    License.find('by').update_attributes(license_type: 'cc')
    License.find('by-sa').update_attributes(license_type: 'cc')
    License.find('by-nd').update_attributes(license_type: 'cc')
    License.find('by-nc').update_attributes(license_type: 'cc')
    License.find('by-nc-sa').update_attributes(license_type: 'cc')
    License.find('by-nc-nd').update_attributes(license_type: 'cc')
    License.find('cc-sample').update_attributes(license_type: 'cc')

    License.find('public').update_attributes(license_type: 'public')
    License.find('copyright').update_attributes(license_type: 'copyright')

    License.find('gpl').update_attributes(license_type: 'gpl')
    License.find('gpl-v2').update_attributes(license_type: 'gpl')
    License.find('gpl-v3').update_attributes(license_type: 'gpl')
    License.find('copyleft').update_attributes(license_type: 'gpl')
  end

  def down
    # do nothing, when rolling back the next migration erases the column
  end
end
