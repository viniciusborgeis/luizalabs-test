class Competitions::CreateUsecase
    def initialize(competition_params)
        @competition_params = competition_params
    end

    def execute
        competition = Competition.new(competition_params)

        competition.save ? competition : competition.errors
    end

    private

    attr_reader :competition_params, :user
end