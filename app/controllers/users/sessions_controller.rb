# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    user = LoginUsecase.new(sign_in_params[:email], sign_in_params[:password]).execute

    if user
      sign_in(user)
      render json: UserPresenter.new(user, 200).login_success, status: :ok
    else
      render json: UserPresenter.new(user, 401).login_failed, status: :unauthorized
    end
  end
  
  private

  def token_from_request
    request.headers['Authorization']&.split(' ')&.last
  end

  def respond_to_on_destroy
    user = LogoutUsecase.new(token_from_request).execute

    if user
      render json: UserPresenter.new(user, 200).logout_success, status: :ok
    else
      render json: UserPresenter.new(user, 401).logout_failed, status: :unauthorized
    end
  end
end
