class Modalities::CreateUsecase
    def initialize(modality_params)
        @modality_params = modality_params
    end

    def execute
        return false unless check_valid_unit
        modality = Modality.new(modality_params)

        modality.save ? modality : modality.errors
    end

    private

    def check_valid_unit
        Modality.unit.include?(modality_params[:unit])
    end

    attr_reader :modality_params
end