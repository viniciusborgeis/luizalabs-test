class LogoutUsecase
    def initialize(token)
        @token = token
    end

    def execute
        user = User.find_by(jti: decoded_token['jti'])
        return unless user
        user
    end

    private

    attr_reader :token

    def decoded_token
       JWT.decode(token.split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first     
    end
end