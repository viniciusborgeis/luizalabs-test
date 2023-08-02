class UserPresenter
    def initialize(user, status_code)
        @user = user
        @status_code = status_code
    end

    def login_success
        response('Logged in sucessfully.', { user: user_data })
    end

    def login_failed
        response('Invalid email or password.')
    end

    def logout_success
        response('Logged out successfully.')
    end

    def logout_failed
        response("Couldn\'t find an active session.")
    end

    def signup_success
        response('Signed up sucessfully.', { user: user_data })
    end

    def signup_failed(message = 'User could not be created successfully.')
        errors_list = user.errors.map {|error| error.message}.uniq.to_sentence
        response(message, { errors: errors_list })
    end

    def generic_error(message)
        response(message)
    end

    private

    attr_reader :user, :status_code

    def response(message, data = nil)
        return { status: status_code, message: message } unless data
        
        { status: { code: status_code, message: message }, data: data }
    end

    def user_data
        UserSerializer.new(user).serializable_hash[:data][:attributes]
    end
end