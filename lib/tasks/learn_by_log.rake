require 'fileutils'
require 'rest-client'
require 'json'
require 'oga'

FETCH_OUT_DIR = File.expand_path('../../../tmp/fetch-log', __FILE__)
TWILOG_URL = 'https://twilog.org'
ACCOUNT_NAME = 'igudhizu'

puts FETCH_OUT_DIR

namespace :learn_by_log do

  desc 'Twilogからログデータを取得する'
  task :fetch, ['page'] => :environment do |_, args|
    max_page = (args.page || 1).to_i

    FileUtils.mkdir_p(FETCH_OUT_DIR)
    max_page.times do |i|
      page = i + 1
      puts "page: #{i}"
      resp = RestClient.get("#{TWILOG_URL}/#{ACCOUNT_NAME}/#{page == 1 ? '' : page}")
      File.open("#{FETCH_OUT_DIR}/#{sprintf('%04d', page)}.html", 'wb') do |f|
        f.write resp
      end
      sleep 1
    end
  end

  desc 'Twilogのログデータを整形する'
  task :parse => :environment do
    tweets = Dir.glob("#{FETCH_OUT_DIR}/*.html").sort.map do |path|
      doc = Oga.parse_html(File.read(path))
      doc.css('.tl-tweet').map do |tweet|
        next unless tweet.css('.tl-name span').text == "@#{ACCOUNT_NAME}"
        tweet.css('.tl-text').text.sub(/^@[^\s]+\s*/, '')
      end.compact
    end.flatten
    File.open("#{FETCH_OUT_DIR}/result.json", 'w') do |f|
      f.write JSON.pretty_generate(tweets)
    end
  end

  desc '整形済みデータから学習を実施する'
  task :learn => :environment do
    tweets = JSON.parse(File.read("#{FETCH_OUT_DIR}/result.json"))
    tweets.each do |tweet|
      learner = Models::Learner.new(tweet)
      if learner.learn
        puts "[success] #{tweet}"
      else
        puts "[skip] #{tweet}"
      end
    end
  end
end
