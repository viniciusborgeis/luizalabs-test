class ResultSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :competition_id, :value
end
