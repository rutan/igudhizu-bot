require 'repp'
require 'twitter'

class CheapTwitter
  REPLY_REGEXP = /<@(\w+?)>/

  class Receive < Repp::Event::Receive
    interface :raw

    def user
      raw.user
    end

    class << self
      def build(tweet)
        new(
          raw: tweet,
          body: tweet.full_text,
          reply_to: tweet.user.screen_name
        )
      end
    end
  end

  class MessageHandler
    attr_reader :client, :app

    def initialize(client, app)
      @client = client
      @app = app
    end

    def handle
      # nothing to do
      loop do
        sleep 10
      end
    end
  end

  class << self
    def run(app, options = {})
      yield self if block_given?

      @client = create_client
      application = app.new

      @ticker = Repp::Ticker.task(application) do |res|
        next if res.first.nil? || res.first.to_s.empty?
        begin
          in_reply_to_status_id = res.last && res.last[:in_reply_to_status_id]
          @client.update(
            res.first,
            in_reply_to_status_id: in_reply_to_status_id
          )
        rescue => e
          puts e.inspect
        end
      end
      @ticker.run!

      handler = MessageHandler.new(@client, application)
      handler.handle
    end

    def stop!
    end

    private

    def create_client
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end
  end
end

Repp::Handler.register 'cheap_twitter', 'CheapTwitter'