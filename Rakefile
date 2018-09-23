require 'bundler/setup'
require 'active_record'

include ActiveRecord::Tasks

task :environment do
  require_relative './lib/bootstrap.rb'
end

load 'active_record/railties/databases.rake'

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each do |path|
  load(path)
end
