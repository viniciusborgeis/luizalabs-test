class CompetitionSerializer
    include JSONAPI::Serializer
    attributes :id, :name, :closed 
    attribute :modality do |object|
        { name: object.modality.name, unit: object.modality.unit }
    end
end