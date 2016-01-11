# Resque tasks
require 'resque/tasks'

task "resque:setup" => :environment

namespace :resque do
  task :setup do
    require 'resque'
  end
end
