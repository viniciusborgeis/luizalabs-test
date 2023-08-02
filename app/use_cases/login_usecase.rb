class LoginUsecase
    def initialize(email, password)
      @email = email
      @password = password
    end
  
    def execute
      user = User.find_for_database_authentication(email: email)
      return nil unless user
      return nil unless user.valid_password?(password)
  
      user
    end
  
    private
  
    attr_reader :email, :password
  end