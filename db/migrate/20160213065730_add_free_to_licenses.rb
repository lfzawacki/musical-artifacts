class AddFreeToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :free, :boolean
  end
end
