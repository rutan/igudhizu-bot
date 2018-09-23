require_relative './bootstrap.rb'
require_relative './twitter_handler.rb'
require 'mobb'

set :name, 'igudhizu_bot'
set :service, 'cheap_twitter'

helpers do
end

# 定期ツイート
cron '0 * * * *' do
  begin
    Models::ParagraphBuilder.build
  rescue => e
    puts e.inspect
    puts e.backtrace
  end
end
