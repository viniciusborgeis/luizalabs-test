class ModalityPresenter < DefaultPresenter
    def initialize(modality, code_success = 200, code_error = 401)
        @modality = modality
        @code_success = code_success
        @code_error = code_error
    end

    def index
        modality ? [index_success, code_success] : [index_error, code_error]
    end

    def show
        modality ? [show_success, code_success] : [show_error, code_error]
    end

    def create
        if !!modality == modality
            generic_error('invalid unit.')
        else
            modality.is_a?(Modality) ? [create_success, code_success] : [create_error, code_error]
        end
    end

    def generic_error(message, code = nil)
        code ||= code_error
        [response(message, code), code]
    end

    private

    attr_reader :modality, :code_success, :code_error

    def index_success
        response('Modalities retrieved successfully.', code_success, { modalities: modality_data })
    end

    def index_error(message = 'No modalities found.')
        default_error(message)
    end

    def show_success
        response('Modality retrieved successfully.', code_success, { modality: modality_data })
    end

    def show_error(message = 'Modality not found.')
        default_error(message)
    end

    def create_success
        response('Modality created successfully.', code_success, { modality: modality_data })
    end

    def create_error(message = 'Modality could not be created successfully.')
        default_error(message)
    end

    def default_error(message)
        if modality.is_a?(ActiveModel::Errors)
            errors_list = modality.errors&.map {|error| error.full_message}.uniq.to_sentence if modality.errors
            return response(message, code_error, { errors: errors_list }) unless errors_list.nil?
        end

        response(message, code_error)
    end

    def modality_data
        if modality.is_a?(ActiveRecord::Relation) 
            modality.map {|mod| modality_data_hash(mod)}
        else
            modality_data_hash(modality)
        end
    end

    def modality_data_hash(modality)
        ModalitySerializer.new(modality).serializable_hash[:data][:attributes]
    end
end