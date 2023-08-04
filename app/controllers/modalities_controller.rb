class ModalitiesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    modalities = Modalities::ShowAllUsecase.new.execute
    response, code = ModalityPresenter.new(modalities).index

    render json: response, status: code
  end

  def show
    modality = Modalities::ShowUsecase.new.execute(params[:id])
    response, code = ModalityPresenter.new(modality, 200, 404).show

    render json: response, status: code
  end

  def create
    authorize current_user, policy_class: ModalityPolicy

    modality = Modalities::CreateUsecase.new(modality_params).execute
    response, code = ModalityPresenter.new(modality, 201, 422).create

    render json: response, status: code
  end

  private

  def modality_params
    params.permit(:name, :unit)
  end
end
