require 'bundler/setup'
require 'mobb/activerecord/rake'

task :environment do
  require_relative './lib/bootstrap.rb'
end

namespace :db do
  task :load_config do
    require_relative './lib/application.rb'
  end
end

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each do |path|
  load(path)
end
