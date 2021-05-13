module Models
  class Learner
    DIC_DIR = File.expand_path('../../../okura-dic', __FILE__)

    def initialize
      @tokenizer = ::Utils::Tokenizer.new
    end

    attr_reader :tokenizer

    def learn(message)
      message = message.to_s
      message = message.sub(/^@[^\s]+\s*/, '') # 先頭のリプライを削除
      message = message.sub('#', '') # ハッシュタグを無効化（迷惑なので）

      return false if bot?(message)
      return false if repry?(message)
      return false if retweet?(message)
      return false if include_url?(message)

      ActiveRecord::Base.transaction do
        words = tokenizer.parse(message).map do |w|
          next if w.blank? || w.first.blank?
          Word.find_or_create_by!(content: w.first, word_type: w.last)
        end.compact

        (words.size + 2).times do |i|
          n = i - 2
          WordChain.find_or_create_by!(
            head_id: n < 0 ? nil : words[n]&.id,
            body_id: n + 1 < 0 ? nil : words[n + 1]&.id,
            foot_id: words[n + 2]&.id
          )
        end
      end
    end

    private

    def bot?(message)
      message.include?('のポスト数：') ||
        message.include?('参戦ID参加者募集')
    end

    def repry?(message)
      !!message.match(/@[^\s]+/)
    end

    def retweet?(message)
      !!message.match(/\s+(RT|QT)\s+/)
    end

    def include_url?(message)
      !!message.match(/https?:/)
    end
  end
end