class ResultsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize current_user, policy_class: ResultPolicy
    result = Results::CreateUsecase.new(current_user, result_parameters.merge(competition_id: params[:id])).execute
    response, code = ResultPresenter.new(result, 201, 422).create

    render json: response, status: code
  end

  private

  def result_parameters
    params.require(:result).permit(:id, :value)
  end
end
