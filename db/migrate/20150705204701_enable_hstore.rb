class EnableHstore < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'
  end
 
  def down
    execute 'DROP EXTENSION IF EXISTS hstore'
  end
end
