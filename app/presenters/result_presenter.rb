class ResultPresenter < DefaultPresenter
  def initialize(result, code_success = 200, code_error = 404)
    @result = result
    @code_success = code_success
    @code_error = code_error
  end

  def create
    result.is_a?(Result) ? [create_success, code_success] : [create_error, code_error]
  end

  private

  attr_accessor :serialize_params
  attr_reader :result, :code_success, :code_error

  def create_success
    response('Result created successfully.', code_success, { result: result_data })
  end

  def create_error(message = 'Result could not be created successfully.')
    default_error(message)
  end

  def default_error(message)
    if result.is_a?(ActiveModel::Errors)
      errors_list = result.errors&.map(&:full_message)&.uniq&.to_sentence
      return response(message, code_error, { errors: errors_list }) unless errors_list.nil?
    end
    response(message, code_error)
  end

  def result_data
    return result_data_hash(result) unless collection?(result)

    result.map { |result| result_data_hash(result) }
  end

  def result_data_hash(result)
    ResultSerializer.new(result).serializable_hash[:data][:attributes]
  end

  def collection?(res)
    res.is_a?(ActiveRecord::Relation) || res.is_a?(Array)
  end
end
