module Models
  class Learner
    DIC_DIR = File.expand_path('../../../okura-dic', __FILE__)

    def initialize(message)
      @message = message.to_s
      @message = @message.sub(/^@[^\s]+\s*/, '') # 先頭のリプライを削除
      @message = @message.sub('#', '') # ハッシュタグを無効化（迷惑なので）
    end

    def learn
      return false if bot?
      return false if repry?
      return false if retweet?
      return false if include_url?

      tokenizer = ::Utils::Tokenizer.new

      ActiveRecord::Base.transaction do
        words = tokenizer.parse(@message).map do |w|
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

    def bot?
      @message.include?('のポスト数：') ||
        @message.include?('参戦ID参加者募集')
    end

    def repry?
      !!@message.match(/@[^\s]+/)
    end

    def retweet?
      !!@message.match(/\s+(RT|QT)\s+/)
    end

    def include_url?
      !!@message.match(/https?:/)
    end
  end
end