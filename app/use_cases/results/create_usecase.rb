class Results::CreateUsecase
  def initialize(user, result_params)
    @user = user
    @result_params = result_params
    @competition = CompetitionGateway.new.show(result_params[:competition_id])
  end

  def execute
    return unless validations

    ResultGateway.new.create(user, result_params)
  end

  private

  def validations
    return false if competition_closed?
    return false if competition_throwing_darts? && user_has_three_or_more_results?

    true
  end

  def competition_closed?
    competition[:closed]
  end

  def competition_throwing_darts?
    competition[:modality][:name] == 'Lançamento de Dardo'
  end

  def user_has_three_or_more_results?
    count = 0
    competition[:all_results].map do |result|
      count += 1 if result[:id] == user.id
    end

    count >= 3
  end

  attr_reader :user, :result_params, :competition
end
