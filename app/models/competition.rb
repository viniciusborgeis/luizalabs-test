class Competition < ApplicationRecord
    belongs_to :user
    has_many :participant
    has_many :result

    validates :name, :end_date, :unit_of_measurement, presence: true
    validates :name, uniqueness: true
    validates :unit_of_measurement, inclusion: { in: %w(seconds meters points) }
    # validates :end_date, date: { after_or_equal_to: Proc.new { Date.today }, message: 'must be after or equal to today' }

    enum unit_of_measurement: {
        seconds: 'seconds',
        meters: 'meters',
        points: 'points'
    }
end
