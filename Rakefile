require 'bundler/setup'
require 'active_record'

load 'active_record/railties/databases.rake'
include ::ActiveRecord::Tasks

task :environment do
  require_relative './lib/bootstrap.rb'
end

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each do |path|
  load(path)
end
