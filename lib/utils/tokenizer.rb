require 'okura'
require 'okura/serializer'

module Utils
  class Tokenizer
    DIC_DIR = File.expand_path('../../../okura-dic', __FILE__)

    def parse(message)
      suffix = nil

      # アヅマさんは「ほげほげほげ（ぴよぴよ」みたいな文章を書きがちなので
      # 末尾の「（ぴよぴよ」部分は単独の単語として切り出す
      message = message.gsub(/(?:\(|（)[^\)）]+(?:\(|（)?\z/) do |m|
        suffix = m
        ''
      end

      words = []
      join_type = nil
      join_word = []

      tagger.parse(message).mincost_path.each do |node|
        word = node.word
        types = word.left.text.split(',')

        if join_type && types.first != join_type
          words << [join_word.join(''), join_type]
          join_word.clear
          join_type = nil
        end

        case types.first
        when 'BOS/EOS'
          words << ['', types.first]
        when '名詞', '記号'
          join_type = types.first
          join_word << word.surface
        when '助詞'
          words << [word.surface, "#{types.first}:#{types.second}"]
        else
          words << [word.surface, types.first]
        end
      end

      words.insert(-2, [suffix, 'アヅマ語尾']) if suffix

      words
    end

    private

    def tagger
      @tagger ||= Okura::Serializer::FormatInfo.create_tagger(DIC_DIR)
    end
  end
end
