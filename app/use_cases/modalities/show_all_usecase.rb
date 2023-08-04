class Modalities::ShowAllUsecase
  def execute
    ModalityGateway.new.show_all
  end
end
