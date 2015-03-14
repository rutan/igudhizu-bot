# encoding: utf-8

require 'mongoid'

module Ruboty
  module Igudhizu
    class ParagraphBuilder
      def initialize
        @start = Word.find_by(text: '')
      end

      def build(range = nil)
        return '' unless @start
        paragraph = generate_base_paragraph(@start, range)

        paragraph.gsub!(/\A[^（]+）/, '') # 閉じカッコが先に出てきたら消す
        paragraph.gsub!('（）（', '（') # カッコ使いすぎでしょ

        paragraph
      end

      private

      def generate_base_paragraph(word, range)
        loop do
          text = generate_by(word)
          return text unless range
          case text.size
          when range
            return text
          end
        end
      end

      def generate_by(word)
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
