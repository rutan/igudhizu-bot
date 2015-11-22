# encoding: utf-8

require 'mongoid'
Mongoid.logger.level = Logger::INFO

module Ruboty
  module Igudhizu
    class Word
      include Mongoid::Document
      store_in collection: 'words'
      field :text, type: String
      has_and_belongs_to_many :prev, class_name: '::Ruboty::Igudhizu::Word', inverse_of: :next
      has_and_belongs_to_many :next, class_name: '::Ruboty::Igudhizu::Word', inverse_of: :prev

      scope :random, -> { skip(rand(self.count)) }
    end
  end
end
