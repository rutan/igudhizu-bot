module Models
  class WordChain < ApplicationRecord
    belongs_to :head, class_name: 'Word'
    belongs_to :body, class_name: 'Word'
    belongs_to :foot, class_name: 'Word'

    validates :head_id, uniqueness: {scope: [:body_id, :foot_id]}
    validate :not_all_empty

    private

    def not_all_empty
      return unless head_id.nil? && body_id.nil? && foot_id.nil?
      errors.add(:head_id, 'all empty')
    end

    class << self
      def random_pick_by_head(head_id = nil)
        empty_query = where(head_id: head_id.try(:id) || head_id)
        empty_query.offset(rand(empty_query.count)).first
      end

      def random_pick_by_body(body_id = nil)
        empty_query = where(body_id: body_id.try(:id) || body_id)
        empty_query.offset(rand(empty_query.count)).first
      end

      def random_pick_by_foot(foot_id = nil)
        empty_query = where(foot_id: foot_id.try(:id) || foot_id)
        empty_query.offset(rand(empty_query.count)).first
      end
    end
  end
end
