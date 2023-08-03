class Competition < ApplicationRecord
    belongs_to :user
    has_many :participant
    has_many :result

    validates :name, :end_date, :unit_of_measurement, presence: true
    validates :name, uniqueness: true
    validates :unit_of_measurement, inclusion: { in: %w(seconds meters points) }
    validate :end_date_cannot_be_in_the_past

    enum unit_of_measurement: {
        seconds: 'seconds',
        meters: 'meters',
        points: 'points'
    }

    private 

    def end_date_cannot_be_in_the_past
        if end_date.present? && end_date < Date.today
            errors.add(:end_date, "must be after or equal to today")
        end
    end   
end

