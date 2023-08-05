class CompetitionPresenter < DefaultPresenter
  def initialize(competition, code_success = 200, code_error = 404)
    @competition = competition
    @code_success = code_success
    @code_error = code_error
    @serialize_params = { params: {} }
  end

  def index(serialize_optional_params = {})
    serialize_params[:params] = serialize_optional_params
    competition ? [index_success, code_success] : [index_error, code_error]
  end

  def show(serialize_optional_params = {})
    serialize_params[:params] = serialize_optional_params
    competition ? [show_success, code_success] : [show_error, code_error]
  end

  def create
    competition.is_a?(Competition) ? [create_success, code_success] : [create_error, code_error]
  end

  def close
    competition.is_a?(Competition) ? [close_success, code_success] : [close_error, code_error]
  end

  private

  attr_accessor :serialize_params
  attr_reader :competition, :code_success, :code_error

  def index_success
    response('Competitions retrieved successfully.', code_success, { competitions: competition_data })
  end

  def index_error(message = 'No competitions found.')
    default_error(message)
  end

  def show_success
    response('Competition retrieved successfully.', code_success, { competition: competition_data })
  end

  def show_error(message = 'Competition not found.')
    default_error(message)
  end

  def create_success
    response('Competition created successfully.', code_success, { competition: competition_data })
  end

  def create_error(message = 'Competition could not be created successfully.')
    default_error(message)
  end

  def close_success
    response('Competition closed successfully.', code_success, { competition: competition_data })
  end

  def close_error(message = 'Competition could not be closed successfully.')
    default_error(message)
  end

  def default_error(message)
    if competition.is_a?(ActiveModel::Errors)
      errors_list = competition.errors&.map(&:full_message)&.uniq&.to_sentence
      return response(message, code_error, { errors: errors_list }) unless errors_list.nil?
    end
    response(message, code_error)
  end

  def competition_data
    return competition_data_hash(competition) unless collection?(competition)

    competition.map { |competition| competition_data_hash(competition) }
  end

  def competition_data_hash(competition)
    CompetitionSerializer.new(competition, serialize_params).serializable_hash[:data][:attributes]
  end

  def collection?(comp)
    comp.is_a?(ActiveRecord::Relation) || comp.is_a?(Array)
  end
end
