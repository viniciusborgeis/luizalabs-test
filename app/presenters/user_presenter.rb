class UserPresenter < DefaultPresenter
    def initialize(user, code_success = 200, code_error = 401)
        @user = user
        @code_success = code_success
        @code_error = code_error
    end

    def sing_up
        user.is_a?(User) ? [signup_success, code_success] : [signup_failed, code_error]
    end

    def generic_error(message)
        [response(message, code_error), code_error]
    end

    def login
        user ? [login_success, code_success] : [login_failed, code_error]
    end

    def logout
        user ? [logout_success, code_success] : [logout_failed, code_error]
    end

    private   

    attr_reader :user, :code_success, :code_error

    def login_success
        response('Logged in sucessfully.', code_success, { user: user_data })
    end

    def login_failed
        response('Invalid email or password.', code_error)
    end

    def logout_success
        response('Logged out successfully.', code_success)
    end

    def logout_failed
        response("Couldn\'t find an active session.", code_error)
    end

    def signup_success
        response('Signed up sucessfully.', code_success, { user: user_data })
    end

    def signup_failed(message = 'User could not be created successfully.')
        errors_list = user.errors.map {|error| error.full_message}.uniq.to_sentence
        response(message, code_error, { errors: errors_list })
    end

    def user_data
        UserSerializer.new(user).serializable_hash[:data][:attributes].to_h
    end
end