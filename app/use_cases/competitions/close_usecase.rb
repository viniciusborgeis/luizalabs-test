class Competitions::CloseUsecase
  def initialize(id)
    @id = id
  end

  def execute
    CompetitionGateway.new.close(id)
  end

  private

  attr_reader :id
end
