class Users::LoginUsecase
  def initialize(email, password)
    @email = email
    @password = password
  end

  def execute
    UserGateway.new.login(email, password)
  end

  private

  attr_reader :email, :password
end
