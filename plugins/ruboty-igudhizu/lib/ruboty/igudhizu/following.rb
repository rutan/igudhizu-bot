
require 'ruboty'

module Ruboty
  module Handlers
    class IgudhizuFollowing < Base
      on(
        /(.*)/m,
        name: 'igudhizu_following',
        description: 'ご主人の語録を蓄える',
        all: true,
      )

      def igudhizu_following(message)
        return unless message.from == master_name
        puts '記憶するか'

        Ruboty::Igudhizu::Learner.new(message.body).learn
      rescue => e
        puts e.inspect
        puts e.backtrace
      end

      private
      def master_name
        ENV['IGUDHIZU_MASTER_NAME'] || 'igudhizu'
      end
    end
  end
end
