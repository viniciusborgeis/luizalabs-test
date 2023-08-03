class CompetitionSerializer
    include JSONAPI::Serializer
    attributes :id, :name,:unit_of_measurement, :end_date
end