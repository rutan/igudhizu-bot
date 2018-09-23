module Models
  class ParagraphBuilder
    def build
      word_ids = []
      last_word = nil
      while true
        if word = WordChain.random_pick_by_head(last_word)
          word_ids.push(word.head_id) if word.head_id
          word_ids.push(word.body_id) if word.body_id
          last_word = word.foot_id
        elsif word = WordChain.random_pick_by_body(last_word)
          word_ids.push(word.body_id) if word.body_id
          last_word = word.foot_id
        else
          raise 'bug!!!!!'
        end
        break if last_word.nil?
      end

      word_ids.map { |id| Word.find(id).content }.join('')
    end
  end
end