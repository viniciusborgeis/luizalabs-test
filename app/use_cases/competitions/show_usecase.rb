class Competitions::ShowUsecase
  def execute(id)
    CompetitionGateway.new.show(id)
  end
end
