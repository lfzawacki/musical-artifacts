class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.string :name
      t.text :description
      t.string :author
      t.string :file
      t.string :file_hash
      t.string :mirrors
      t.text :file_list

      t.integer :license_id

      t.boolean :compressed

      t.timestamps null: false
    end
  end
end
