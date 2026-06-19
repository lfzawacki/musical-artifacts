class AddIndexToTaggingsOnTypeContextTagId < ActiveRecord::Migration
  def up
    add_index :taggings, [:taggable_type, :context, :tag_id],
              name: "index_taggings_on_type_context_tag_id"
  end

  def down
    remove_index :taggings, name: "index_taggings_on_type_context_tag_id"
  end
end
