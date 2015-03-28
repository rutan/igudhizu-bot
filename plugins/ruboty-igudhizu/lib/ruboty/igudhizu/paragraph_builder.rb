# encoding: utf-8

require 'mongoid'

module Ruboty
  module Igudhizu
    class ParagraphBuilder
      def initialize
        @start = Word.find_by(text: '')
      end
      attr_reader :start

      def start=(text)
        @start =
          if text.kind_of?(Word)
            text
          else
            begin
              Word.find_by(text: text)
            rescue Mongoid::Errors::DocumentNotFound => _
              Word.find_by(text: '')
            end
          end
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
          text =
            if word.text.size == 0
              generate_by(word)
            else
              "#{generate_prev_by(word)}#{word.text}#{generate_by(word)}"
            end
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

      def generate_prev_by(word)
        words = []
        while word = word.prev.random.first
          break if word.nil? or word.text.size == 0
          words.unshift word.text
        end
        words.join('')
      end
    end
  end
end
