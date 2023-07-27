class Competition < ApplicationRecord
    enum unit_of_measurement: {
        seconds: 'seconds',
        meters: 'meters',
        points: 'points'
    }

    validates :name, :end_date, :unit_of_measurement, presence :true
end
