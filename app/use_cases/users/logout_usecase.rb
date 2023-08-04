class Users::LogoutUsecase
  def initialize(token)
    @token = token
  end

  def execute
    UserGateway.new.logout(decoded_token)
  end

  private

  attr_reader :token

  def decoded_token
    JWT.decode(token.split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
  end
end
