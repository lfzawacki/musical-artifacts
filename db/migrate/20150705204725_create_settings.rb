class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.hstore :data

      t.timestamps null: false
    end
  end
end
