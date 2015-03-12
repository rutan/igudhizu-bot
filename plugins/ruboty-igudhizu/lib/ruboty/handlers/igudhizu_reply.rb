require 'ruboty'

module Ruboty
  module Handlers
    class IgudhizuReply < Base
      on(
        /(.*)/m,
        name: 'igudhizu_reply',
        description: 'テキトーに返す'
      )

      def initialize(*args)
        super
        create_builder
      end

      def igudhizu_reply(message)
        message.reply(@builder.build(1..120))
      rescue => e
        puts e.inspect
        puts e.backtrace
      end

      private

      def create_builder
        Ruboty::Igudhizu.init
        @builder = Ruboty::Igudhizu::ParagraphBuilder.new
      end
    end
  end
end
