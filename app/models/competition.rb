class Competition < ApplicationRecord
  belongs_to :user
  belongs_to :modality
  has_many :participant
  has_many :result

  validates :name, :modality, presence: true
  validates :name, uniqueness: true
  validates :modality, inclusion: { in: Modality.all }
end
