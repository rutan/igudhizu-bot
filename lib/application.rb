require 'mobb/base'
require_relative './bootstrap.rb'
require_relative './twitter_handler.rb'

class IgudhizuBot < Mobb::Base
  set :name, 'igudhizu_bot'
  set :service, 'cheap_twitter' unless ENV['TWITTER_ACCESS_TOKEN'].to_s.empty?

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
  cron '*/10 * * * *' do
    generate_talk if rand < 0.1
  end
end
