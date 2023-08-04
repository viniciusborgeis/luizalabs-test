class ModalityGateway
  def show_all
    Modality.all
  end

  def show(id)
    Modality.find_by_id(id)
  end

  def create(modality_params)
    return false unless check_valid_unit(modality_params)

    modality = Modality.new(modality_params)

    modality.save ? modality : modality.errors
  end

  private

  def check_valid_unit(modality_params)
    Modality.unit.include?(modality_params[:unit])
  end
end
