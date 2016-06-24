class AddHasIntegrationToApps < ActiveRecord::Migration
  def change
    add_column :apps, :has_integration, :boolean
  end
end
