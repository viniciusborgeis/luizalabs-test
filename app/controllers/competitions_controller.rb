class CompetitionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        competitions = Competition.all
        response, code = CompetitionPresenter.new(competitions).index

        render json: response, status: code
    end

    def show
        competition = Competition.find_by_id(params[:id])
        response, code = CompetitionPresenter.new(competition).show

        render json: response, status: code
    end

    def create
        params  = { user_id: current_user.id }.merge(competition_parameters)

        competition = Competitions::CreateUsecase.new(params).execute
        response, code = CompetitionPresenter.new(competition, 201, 422).create

        render json: response, status: code
    end

    def close
        competition = Competitions::CloseUsecase.new(params[:id]).execute
        response, code = CompetitionPresenter.new(competition).close

        render json: response, status: code
    end

    private

    def competition_parameters
        competition_params = params.require(:competition).permit(:name, :unit_of_measurement, :end_date)
    end
end
