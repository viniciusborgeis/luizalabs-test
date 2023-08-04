class Modalities::ShowUsecase
  def execute(id)
    ModalityGateway.new.show(id)
  end
end
