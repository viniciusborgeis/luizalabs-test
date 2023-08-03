class CompetitionPresenter < DefaultPresenter
    def initialize(competition, code_success = 200, code_error = 404)
        @competition = competition
        @code_success = code_success
        @code_error = code_error
    end

    def index
        competition ? [index_success, code_success] : [index_error, code_error]
    end

    def show
        competition ? [show_success, code_success] : [show_error, code_error]
    end

    def create
        competition.is_a?(Competition) ? [create_success, code_success] : [create_error, code_error]
    end

    def close
        competition.is_a?(Competition) ? [close_success, code_success] : [close_error, code_error]
    end

    
    private

    attr_reader :competition, :code_success, :code_error


    def index_success
        response('Competitions retrieved successfully.', code_success, { competitions: competition_data })
    end

    def index_error(message = 'No competitions found.')
        default_error(message)
    end

    def show_success
        response('Competition retrieved successfully.', code_success, { competition: competition_data })
    end

    def show_error(message = 'Competition not found.')
        default_error(message)
    end

    def create_success
        response('Competition created successfully.', code_success, { competition: competition_data })
    end

    def create_error(message = 'Competition could not be created successfully.')
        default_error(message)
    end

    def close_success
        response('Competition closed successfully.', code_success, { competition: competition_data })
    end

    def close_error(message = 'Competition could not be closed successfully.')
        default_error(message)
    end




    def default_error(message)
        if competition.is_a?(ActiveModel::Errors)
            errors_list = competition.errors&.map {|error| error.full_message}.uniq.to_sentence if competition.errors
            return response(message, code_error, { errors: errors_list }) unless errors_list.nil?
        end
        response(message, code_error)
    end

    def competition_data
        if competition.is_a?(ActiveRecord::Relation) 
            competition.map {|competition| competition_data_hash(competition)}
        else
            competition_data_hash(competition)
        end
    end

    def competition_data_hash(competition)
        CompetitionSerializer.new(competition).serializable_hash[:data][:attributes]
    end
end