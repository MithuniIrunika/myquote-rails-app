class Category < ApplicationRecord
  has_many :quote_categories, dependent: :destroy
  has_many :quotes, through: :quote_categories

  validates :catname, presence: { message: "Category name cannot be blank" },
                      uniqueness: { case_sensitive: false,
                                    message: "already exists" },
                      length: { maximum: 50 }
end