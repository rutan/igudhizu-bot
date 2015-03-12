# encoding: utf-8

module Ruboty
  module Igudhizu
    class Learner
      def initialize(text)
        @text = text.to_s.strip
        @words = {}
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

      # TODO: 無駄が多いのでなんとかしたいなぁ
      def learn
        return unless lernable?
        @words.clear

        # わかち分け
        splitter = Splitter.new(text.strip)
        src_words = splitter.words

        # ペアの作成
        (src_words.size - 1).times do |i|
          pair_word src_words[i], src_words[i + 1]
          pair_word src_words[i], "#{src_words[i + 1]}#{src_words[i + 2]}"
          if i > 2
            #pair_word "#{src_words[i - 2]}#{src_words[i - 1]}", src_words[i]
            pair_word "#{src_words[i - 2]}#{src_words[i - 1]}", "#{src_words[i]}#{src_words[i + 1]}"
          end
        end

        # ペアの保存
        @words.each do |word, next_words|
          w1 = Word.find_or_create_by(text: word)
          next_words.uniq.each do |next_word|
            w2 = Word.find_or_create_by(text: next_word)
            w1.next.push w2
            w2.prev.push w1
            w2.save
          end
          w1.save
        end
      end

      private

      def pair_word(s1, s2)
        @words[s1] ||= []
        @words[s1].push s2
      end
    end
  end
end
