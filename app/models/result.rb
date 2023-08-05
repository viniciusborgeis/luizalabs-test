class Result < ApplicationRecord
  belongs_to :user
  belongs_to :competition

  validates :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
