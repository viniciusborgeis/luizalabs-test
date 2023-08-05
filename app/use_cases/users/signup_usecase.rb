class Users::SignupUsecase
  def initialize(user_params)
    @user_params = user_params
  end

  def execute
    UserGateway.new.sign_up(user_params)
  end

  private

  attr_reader :user_params
end
