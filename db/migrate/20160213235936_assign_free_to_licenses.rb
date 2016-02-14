class AssignFreeToLicenses < ActiveRecord::Migration
  def up
    free = ['cc-sample', 'by', 'by-sa', 'falv13', 'copyleft', 'gpl', 'gpl-v2', 'gpl-v3', 'public']
    non_free = ['by-nc', 'by-nd', 'by-nc', 'by-nc-sa', 'by-nc-nd', 'copyright', 'various', 'gray']

    License.where(short_name: free).each { |l| l.update_attribute :free, true }
    License.where(short_name: non_free).each { |l| l.update_attribute :free, false }
  end


  def down
    # nothing
  end
end
