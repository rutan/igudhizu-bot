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
        # メッセージから名詞をテキトーに1個取り出す
        reply_message = message.body.gsub(/\s?@[A-Za-z0-9]+\s?/, '')
        splitter = Ruboty::Igudhizu::Splitter.new(reply_message)
        @builder.start = splitter.nouns.sample.to_s
        message.reply("#{message.from ? "@#{message.from} " : ''}#{@builder.build(1..80)}") unless message.original[:retweeted]
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
