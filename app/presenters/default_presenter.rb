class DefaultPresenter
    protected

    def response(message, status_code, data = nil)
        return { status: status_code, message: message } unless data
        
        { status: { code: status_code, message: message }, data: data }
    end
end