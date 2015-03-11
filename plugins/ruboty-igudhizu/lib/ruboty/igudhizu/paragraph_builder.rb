# encoding: utf-8

require 'mongoid'

module Ruboty
  module Igudhizu
    class ParagraphBuilder
      def initialize
        @start = Word.find_by(text: '')
      end

      def build
        return '' unless @start

        word = @start
        words = []
        while word = word.next.random.first
          break if word.nil? or word.text.size == 0
          words << word.text
        end
        words.join('')
      end
    end
  end
end
