class ResultGateway
  def create(user, result_params)
    result = user.results.new(result_params)

    result.save ? result : result.errors
  end
end
