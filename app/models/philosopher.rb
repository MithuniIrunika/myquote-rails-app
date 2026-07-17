class Philosopher < ApplicationRecord
  has_many :quotes, dependent: :nullify

  validates :fname, presence: { message: "Philosopher first name cannot be blank" },
                    length: { maximum: 100 }
  validates :lname, length: { maximum: 100 }
  validates :byear, length: { maximum: 20 }
  validates :dyear, length: { maximum: 20 }

  def display_name
    [fname, lname].compact.reject(&:blank?).join(" ")
  end

  def life_span
    return "" if byear.blank?
    dyear.present? ? "(#{byear} – #{dyear})" : "(b. #{byear})"
  end
end