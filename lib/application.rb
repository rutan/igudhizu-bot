require_relative './bootstrap.rb'
require_relative './twitter_handler.rb'
require 'mobb'

set :name, 'igudhizu_bot'
set :service, 'cheap_twitter'

helpers do
  def generate_talk
    begin
      Models::ParagraphBuilder.build
    rescue => e
      puts e.inspect
      puts e.backtrace
    end
  end
end

on /.+/ do
  generate_talk
end

# 定期ツイート
cron '0 * * * *' do
  generate_talk
end
