class DefaultPresenter
  protected

  def response(message, status_code, data = nil)
    return { status: status_code, message: } unless data

    { status: { code: status_code, message: }, data: }
  end
end
