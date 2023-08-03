# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    user = Users::LoginUsecase.new(sign_in_params[:email], sign_in_params[:password]).execute
    sign_in(user) if user
    response, code = UserPresenter.new(user, 200, 401).login
    
    render json: response, status: code
  end
  
  private

  def token_from_request
    request.headers['Authorization']&.split(' ')&.last
  end

  def respond_to_on_destroy
    user = Users::LogoutUsecase.new(token_from_request).execute
    response, code = UserPresenter.new(user, 200, 401).logout

    render json: response, status: code
  end
end
