class Competitions::CreateUsecase
  def initialize(user, competition_params)
    @user = user
    @competition_params = competition_params
  end

  def execute
    CompetitionGateway.new.create({ user_id: user.id }.merge(competition_params))
  end

  private

  attr_reader :user, :competition_params
end
