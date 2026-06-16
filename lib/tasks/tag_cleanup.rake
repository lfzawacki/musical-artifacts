namespace :tag_cleanup do
  desc "Enqueue TagCleanupWorker to fix tag formatting (config/tag_cleanup.yml)"
  task run: :environment do
    Resque.enqueue(TagCleanupWorker)
    puts "TagCleanupWorker enqueued on :low queue"
  end

  desc "Run tag cleanup inline (bypasses Resque, runs immediately)"
  task run_now: :environment do
    TagCleanupWorker.perform
  end
end
