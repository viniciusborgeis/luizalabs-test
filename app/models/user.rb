class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :competitions
  has_many :participants
  has_many :results

  validates :name, :role, presence: true
  validates :password, length: 6..15
  validates :email, presence: true, uniqueness: true, format: { with: Devise::email_regexp }

  enum role: [:athlete, :committee]
end
