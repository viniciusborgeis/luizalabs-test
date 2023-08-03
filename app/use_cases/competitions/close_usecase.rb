class Competitions::CloseUsecase
    def initialize(id)
        @id = id
    end

    def execute
        competition = Competition.find_by_id(id)

        competition if competition.is_a?(Competition) && competition.update_attribute(:end_date, Time.now)
    end

    private

    attr_reader :id
end