class Modality < ApplicationRecord
    has_many :competition

    validates :name, presence: true, uniqueness: true
    validates :unit, inclusion: { in: %w(seconds meters) }
    
    enum unit: { seconds: 0, meters: 1 }

    def self.unit
        units.keys
    end
end
