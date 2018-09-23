module Models
  class Word < ApplicationRecord
    class << self
      def random_by_type(word_type)
        query = where(word_type: word_type)
        query.offset(rand(query.count)).first
      end
    end
  end
end
