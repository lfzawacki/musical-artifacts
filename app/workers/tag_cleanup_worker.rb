#
# Tag Cleanup Worker
# ==================
# Editable rules in config/tag_cleanup.yml (moves, renames, removes, strip_dots)
#
# Enqueue to Resque:  bundle exec rake tag_cleanup:run
# Run inline:         bundle exec rake tag_cleanup:run_now
# Rails console:      TagCleanupWorker.perform
# System cron daily:  0 3 * * * cd /app/current && bundle exec rake tag_cleanup:run
#

class TagCleanupWorker
  @queue = :low

  LIST_METHODS = {
    'tags'         => 'tag_list',
    'file_formats' => 'file_format_list',
    'software'     => 'software_list'
  }

  def self.perform(config = nil)
    config ||= YAML.load_file(Rails.root.join('config', 'tag_cleanup.yml'))

    process_moves(config['moves'])
    process_renames(config['renames'])
    process_removes(config['removes'])
    process_strip_dots(config['strip_dots'])

    Resque.logger.info(" * [TagCleanup] Done")
  end

  private

  def self.process_moves(moves)
    (moves || []).each do |move|
      from = move['from']
      to   = move['to']
      list_method = LIST_METHODS[from]
      dest_method = LIST_METHODS[to]

      move['values'].each do |value|
        Resque.logger.info(" * [TagCleanup] Moving '#{value}' from #{from} to #{to}")
        count = 0
        Artifact.tagged_with(value, on: from).find_each do |artifact|
          artifact.send(list_method).remove(value)
          dest_list = artifact.send(dest_method)
          dest_list.add(value) unless dest_list.include?(value)
          artifact.save
          count += 1
        end
        Resque.logger.info(" * [TagCleanup]   Updated #{count} artifacts")
      end
    end
  end

  def self.process_renames(renames)
    (renames || {}).each do |context, mappings|
      list_method = LIST_METHODS[context]

      mappings.each do |from_value, to_value|
        Resque.logger.info(" * [TagCleanup] Renaming '#{from_value}' -> '#{to_value}' in #{context}")
        count = 0
        Artifact.tagged_with(from_value, on: context).find_each do |artifact|
          list = artifact.send(list_method)
          list.remove(from_value)
          list.add(to_value) unless list.include?(to_value)
          artifact.save
          count += 1
        end
        Resque.logger.info(" * [TagCleanup]   Updated #{count} artifacts")
      end
    end
  end

  def self.process_removes(removes)
    (removes || []).each do |remove|
      from = remove['from']
      list_method = LIST_METHODS[from]

      remove['values'].each do |value|
        Resque.logger.info(" * [TagCleanup] Removing '#{value}' from #{from}")
        count = 0
        Artifact.tagged_with(value, on: from).find_each do |artifact|
          artifact.send(list_method).remove(value)
          artifact.save
          count += 1
        end
        Resque.logger.info(" * [TagCleanup]   Updated #{count} artifacts")
      end
    end
  end

  def self.process_strip_dots(contexts)
    (contexts || []).each do |context|
      list_method = LIST_METHODS[context]

      dotted_tags = ActsAsTaggableOn::Tagging
        .where(context: context, taggable_type: 'Artifact')
        .joins(:tag)
        .where("tags.name LIKE '.%'")
        .pluck('DISTINCT tags.name')

      next if dotted_tags.empty?

      Resque.logger.info(" * [TagCleanup] Stripping dots from #{context}: #{dotted_tags.inspect}")

      dotted_tags.each do |tag_name|
        clean_name = tag_name.sub(/^\.+/, '')
        next if clean_name.blank? || clean_name == tag_name

        count = 0
        Artifact.tagged_with(tag_name, on: context).find_each do |artifact|
          list = artifact.send(list_method)
          list.remove(tag_name)
          list.add(clean_name) unless list.include?(clean_name)
          artifact.save
          count += 1
        end
        Resque.logger.info(" * [TagCleanup]   #{tag_name} -> #{clean_name}: #{count} artifacts")
      end
    end
  end
end
