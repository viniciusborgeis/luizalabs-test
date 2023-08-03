class ModalitiesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        modalities = Modality.all
        response, code = ModalityPresenter.new(modalities).index

        render json: response, status: code
    end
    
    def show
        modality = Modality.find_by_id(params[:id])
        response, code = ModalityPresenter.new(modality, 200, 404).show

        render json: response, status: code
    end

    def create
        modality = Modalities::CreateUsecase.new(modality_params).execute
        response, code = ModalityPresenter.new(modality, 201, 422).create

        render json: response, status: code
    end

    private

    def modality_params
        modality_params = params.require(:modality).permit(:name, :unit)
    end
end