require 'okura'
require 'okura/serializer'

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

      ActiveRecord::Base.transaction do
        words = parse_words.map do |w|
          next if w.blank?
          Word.find_or_create_by!(content: w)
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
      !!@message.include?('のポスト数：')
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

    def parse_words
      suffix = nil

      # アヅマさんは「ほげほげほげ（ぴよぴよ」みたいな文章を書きがちなので
      # 末尾の「（ぴよぴよ」部分は単独の単語として切り出す
      message = @message.gsub(/(?:\(|（)[^\)）]+(?:\(|（)?\z/) do |m|
        suffix = m
        ''
      end

      words = []
      join_word = []
      tagger.parse(message).mincost_path.each do |node|
        word = node.word
        types = word.left.text.split(',')
        case types.first
        when 'BOS/EOS'
          if join_word.size > 0
            words << join_word.join('')
            join_word.clear
          end
          words << ''
        when '名詞'
          join_word << word.surface
        else
          if join_word.size > 0
            words << join_word.join('')
            join_word.clear
          end
          words << word.surface
        end
      end

      words.insert(-2, suffix) if suffix

      words
    end

    def tagger
      @tagger ||= Okura::Serializer::FormatInfo.create_tagger(DIC_DIR)
    end
  end
end