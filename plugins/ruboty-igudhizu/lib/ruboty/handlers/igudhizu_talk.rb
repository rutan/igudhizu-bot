require 'ruboty'

module Ruboty
  module Handlers
    class IgudhizuTalk < Base

      def initialize(*args)
        super
        create_builder
        reserve
      end

      def random_say
        robot.say(body: @builder.build(1..80), original: {})
      rescue => e
        puts e.inspect
        puts e.backtrace
      end

      private

      def create_builder
        Ruboty::Igudhizu.init
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
    end
  end
end
