class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name
      t.string :short_name
      t.string :url

      t.timestamps null: false
    end
  end
end
