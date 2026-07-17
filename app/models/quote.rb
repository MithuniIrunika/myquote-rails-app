class Quote < ApplicationRecord
  belongs_to :user
  belongs_to :philosopher

  has_many :quote_categories, dependent: :destroy
  has_many :categories, through: :quote_categories

  accepts_nested_attributes_for :quote_categories, reject_if: :all_blank, allow_destroy: true

  validates :qtext, presence: { message: "Quote text cannot be blank" },
                    length: { maximum: 1000, message: "is too long (max 1000 characters)" }
  validates :qyear, length: { maximum: 20 }
  validates :qcom,  length: { maximum: 500 }
  validates :user_id,        presence: true
  validates :philosopher_id, presence: { message: "Please select a philosopher" }

  validate :must_have_at_least_one_category

  scope :public_quotes, -> { where(ispublic: true) }
  scope :recent,        -> { order(created_at: :desc) }

  private

  def must_have_at_least_one_category
    if quote_categories.reject(&:marked_for_destruction?).empty? && categories.empty?
      errors.add(:base, "A quote must be assigned to at least one category")
    end
  end
end