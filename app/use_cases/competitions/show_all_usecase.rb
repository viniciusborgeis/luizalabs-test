class Competitions::ShowAllUsecase
  def execute
    CompetitionGateway.new.show_all
  end
end
