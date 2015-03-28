# encoding: utf-8

require 'okura/serializer'

module Ruboty
  module Igudhizu
    class Splitter
      def initialize(text)
        @text = text.to_s
        @words = []
        @nouns = []
        step_url
        step_remove_retweet
        step_remove_hash
        step_morphological
      end
      attr_reader :text
      attr_reader :words
      attr_reader :nouns

      # URL付きの場合はURL以降のみ残す
      def step_url
        return unless @text.match(/https?:\/\//)
        @text = @text.split(/https?:\/\/[^\s]+/).last.to_s
      end

      # 非公式RTを消す
      def step_remove_retweet
        @text.gsub!(/\s+RT\s+\@.+\z/, '')
      end

      # ハッシュタグを消す
      def step_remove_hash
        @text.gsub!(/\s*#[^\s]+\s*\z/, '')
      end

      # 形態素解析する
      def step_morphological
        @words.clear
        @nouns.clear

        join_word = []
        tagger.parse(@text).mincost_path.each do |node|
          word = node.word
          types = word.left.text.split(',')
          case types.first
          when 'BOS/EOS'
            if join_word.size > 0
              @words << join_word.join('')
              @nouns << join_word.join('')
              join_word.clear
            end
            @words << ''
          when '名詞'
            join_word << word.surface
          else
            if join_word.size > 0
              @words << join_word.join('')
              @nouns << join_word.join('')
              join_word.clear
            end
            @words << word.surface
          end
        end
      end

      def tagger
        self.class.tagger
      end

      def self.tagger
        @tagger ||= Okura::Serializer::FormatInfo.create_tagger(DIC_DIR)
      end

      DIC_DIR = File.expand_path('../../../../okura-dic', __FILE__)
    end
  end
end
