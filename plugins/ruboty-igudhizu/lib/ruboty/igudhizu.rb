require 'ruboty/igudhizu/version'
require 'ruboty/igudhizu/override'
require 'ruboty/igudhizu/word'
require 'ruboty/igudhizu/splitter'
require 'ruboty/igudhizu/learner'
require 'ruboty/igudhizu/paragraph_builder'
require 'ruboty/igudhizu/following'

require 'ruboty'

module Ruboty
  module Handlers
    class Igudhizu < Base
      on(
        /(.*)/m,
        name: 'igudhizu_reply',
        description: 'テキトーに返す'
      )

      def initialize(*args)
        super
        builder_setup
        reserve
      end

      def igudhizu_reply(message)
        message.reply(generate)
      rescue => e
        puts e.inspect
        puts e.backtrace
      end

      def random_say
        robot.say(body: generate, original: {})
      rescue => e
        puts e.inspect
        puts e.backtrace
      end

      private

      def builder_setup
        ENV['MONGOID_ENV'] ||= 'development'
        Mongoid.load!(mongoid_config_path)
        @builder = Ruboty::Igudhizu::ParagraphBuilder.new
      end

      def reserve
        Thread.new do
          loop do
            sleep interval
            random_say
          end
        end.run
      end

      def interval
        (ENV['IGUDHIZU_INTERVAL'] || 30 * 60).to_i * (1 + rand(10) / 100.0)
      end

      def generate
        loop do
          message = @builder.build.to_s
          return message if message.size > 0 && message.size < 120
        end
      end

      def mongoid_config_path
        ENV['MONGOID_CONFIG_PATH'] || File.expand_path('../../../mongoid.yml', __FILE__)
      end
    end
  end
end
