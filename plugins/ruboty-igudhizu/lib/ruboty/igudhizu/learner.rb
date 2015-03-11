# encoding: utf-8

module Ruboty
  module Igudhizu
    class Learner
      def initialize(text)
        @text = text.to_s.strip
      end
      attr_reader :text

      def lernable?
        return false unless text.size > 0 # length
        return false if text.match(/@[A-Za-z0-9_]+/) # reply
        return false if text.match(/\#[^\s]+(\s|$)/) # hash
        return false if text.match(/https?:\/\/.+/) # URL
        return false if text.match(/[「」『』【】・　]/) # invalid mark
        true
      end

      def learn
        return unless lernable?

        splitter = Splitter.new(text.strip)
        src_words = splitter.words
        (src_words.size - 1).times do |i|
          link_word src_words[i], src_words[i + 1]
          link_word src_words[i], "#{src_words[i + 1]}#{src_words[i + 2]}"
          if i > 2
            #link_word "#{src_words[i - 2]}#{src_words[i - 1]}", src_words[i]
            link_word "#{src_words[i - 2]}#{src_words[i - 1]}", "#{src_words[i]}#{src_words[i + 1]}"
          end
        end
      end

      def link_word(s1, s2)
        word1 = Word.find_or_create_by(text: s1)
        word2 = Word.find_or_create_by(text: s2)
        word1.next.push word2
        word2.prev.push word1
        word1.save
        word2.save
      end
    end
  end
end
