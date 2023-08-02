class SignupUsecase
    def initialize(user_params)
        @user_params = user_params
    end

    def execute
        user = User.new(user_params)

        user.save ? user : user.errors
    end

    private

    attr_reader :user_params
end