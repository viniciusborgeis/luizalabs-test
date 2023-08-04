class CompetitionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    competitions = Competitions::ShowAllUsecase.new.execute
    response, code = CompetitionPresenter.new(competitions).index({ show_all: true })

    render json: response, status: code
  end

  def show
    competition = Competitions::ShowUsecase.new.execute(params[:id])
    response, code = CompetitionPresenter.new(competition).show({ show: true })

    render json: response, status: code
  end

  def create
    authorize current_user, policy_class: CompetitionPolicy

    competition = Competitions::CreateUsecase.new(current_user, competition_parameters).execute
    response, code = CompetitionPresenter.new(competition, 201, 422).create

    render json: response, status: code
  end

  def close
    authorize current_user, policy_class: CompetitionPolicy

    competition = Competitions::CloseUsecase.new(params[:id]).execute
    response, code = CompetitionPresenter.new(competition).close

    render json: response, status: code
  end

  private

  def competition_parameters
    params.require(:competition).permit(:name, :modality_id)
  end
end
