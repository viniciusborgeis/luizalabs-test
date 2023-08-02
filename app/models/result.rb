class Result < ApplicationRecord
  belongs_to :user
  belongs_to :competition

  validates :value, presence: true
end
