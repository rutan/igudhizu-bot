require_relative './bootstrap.rb'
require_relative './twitter_handler.rb'
require 'mobb'
require 'mobb/activerecord'

set :database_file, File.expand_path('../../db/config.yml', __FILE__)

set :name, 'igudhizu_bot'
set :service, 'cheap_twitter'

helpers do
  def generate_talk(keywords = nil)
    begin
      Models::ParagraphBuilder.build(keyword: keywords)
    rescue ActiveRecord::RecordNotFound
      Models::ParagraphBuilder.build
    rescue => e
      puts e.inspect
      puts e.backtrace
    end
  end
end

on /(.+)/ do |word|
  begin
    keywords = Utils::Tokenizer.new.parse(word.gsub(/@[^\s]+/, '').strip)
                 .select {|n| n.last == '名詞'}
                 .map(&:first)
                 .compact
                 .uniq
                 .shuffle
    generate_talk(keywords)
  rescue => e
    puts e.inspect
    puts e.backtrace
    generate_talk
  end
end

# 定期ツイート
cron '0 * * * *' do
  generate_talk
end
