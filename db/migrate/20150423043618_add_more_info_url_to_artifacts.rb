class AddMoreInfoUrlToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :more_info_urls, :string
  end
end
