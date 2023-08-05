class CompetitionSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :closed
  attributes :modality do |object|
    { name: object.modality[:name], unit: object.modality[:unit] }
  end
  attributes :participants, :winner, if: proc { |_record, params|
                                           params && (params[:show_all] == true || params[:show] == true)
                                         }
  attributes :best_results, if: proc { |_record, params| params && params[:show_all] == true }
  attributes :all_results, if: proc { |_record, params| params && params[:show] == true }
end
