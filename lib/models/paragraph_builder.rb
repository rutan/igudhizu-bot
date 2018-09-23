require 'timeout'

module Models
  class ParagraphBuilder
    def build(keyword: nil)
      case keyword
      when String
        keyword = Word.find_by(content: keyword)&.id || (raise ActiveRecord::RecordNotFound)
      when Word
        keyword = keyword.id
      end

      first_ids = keyword ? chain_top(keyword) : []
      last_ids = chain_bottom(keyword)
      first_ids.pop if first_ids.present? && last_ids.present?

      words = (first_ids + last_ids).map { |id| Word.find(id) }
      words.map(&:content).join('')
    end

    private

    def chain_top(start_word = nil)
      word_ids = []
      while true
        if word = WordChain.random_pick_by_foot(start_word)
          word_ids.unshift(word.foot_id) if word.foot_id
          word_ids.unshift(word.body_id) if word.body_id
          start_word = word.head_id
        elsif start_word && word = WordChain.random_pick_by_body(start_word)
          word_ids.unshift(word.body_id) if word.body_id
          start_word = word.head_id
        else
          start_word = nil
        end
        break if start_word.nil?
      end
      word_ids
    end

    def chain_bottom(last_word = nil)
      word_ids = []
      while true
        if word = WordChain.random_pick_by_head(last_word)
          word_ids.push(word.head_id) if word.head_id
          word_ids.push(word.body_id) if word.body_id
          last_word = word.foot_id
        elsif last_word && word = WordChain.random_pick_by_body(last_word)
          word_ids.push(word.body_id) if word.body_id
          last_word = word.foot_id
        else
          last_word = nil
        end
        break if last_word.nil?
      end
      word_ids
    end

    class NeedRetryError < StandardError; end

    class << self
      def build(options = {})
        builder = self.new
        Timeout.timeout(options[:timeout] || 5) do
          begin
            builder.build(keyword: options[:keyword]).tap do |text|
              raise NeedRetryError, 'too long' if text.size >= 100
              raise NeedRetryError, 'many paragraph' if text.count('。') >= 2
              raise NeedRetryError, 'invalid brackets' if text.count('(（') < text.count(')）')
              raise NeedRetryError, 'invalid brackets' if text.match(/\A[^\(（]+(?:\)|）)/)
              raise NeedRetryError, 'invalid brackets' unless text.count('「『') == text.count('」』')
              raise NeedRetryError, 'invalid brackets' if text.match(/\A[^「]+」/)
            end
          rescue NeedRetryError
            retry
          end
        end
      end
    end
  end
end