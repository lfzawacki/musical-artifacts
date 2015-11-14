atom_feed do |feed|
  feed.title(application_title)
  feed.updated((@artifacts.first.created_at))

  @artifacts.each do |artifact|
    feed.entry(artifact) do |entry|
      entry.title(artifact.name)
      entry.content(artifact.description_html, type: 'html')

      entry.author do |creator|
        creator.name(artifact.author)
      end
    end
  end
end