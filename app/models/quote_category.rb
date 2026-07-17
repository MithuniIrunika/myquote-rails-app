class QuoteCategory < ApplicationRecord
  belongs_to :quote
  belongs_to :category

  validates :category_id, presence: true
  validates :quote_id, uniqueness: { scope: :category_id,
                                     message: "duplicate category for this quote" }
end