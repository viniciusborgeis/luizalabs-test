class Modalities::CreateUsecase
  def initialize(modality_params)
    @modality_params = modality_params
  end

  def execute
    ModalityGateway.new.create(modality_params)
  end

  attr_reader :modality_params
end
