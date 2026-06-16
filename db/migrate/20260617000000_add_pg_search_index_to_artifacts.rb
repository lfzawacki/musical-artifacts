class AddPgSearchIndexToArtifacts < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_artifacts_on_tsvector_metadata
        ON artifacts
        USING GIN (to_tsvector('english',
          coalesce(name, '') || ' ' ||
          coalesce(description, '') || ' ' ||
          coalesce(author, '') || ' ' ||
          coalesce(extra_license_text, '')
        ))
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS index_artifacts_on_tsvector_metadata"
  end
end
