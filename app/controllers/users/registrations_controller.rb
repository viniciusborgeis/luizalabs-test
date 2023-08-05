# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  before_action :check_valid_type, only: [:create]

  def create
    user = Users::SignupUsecase.new(sign_up_params).execute
    response, code = UserPresenter.new(user, 201, 422).sing_up

    render json: response, status: code
  end

  private

  def check_valid_type
    is_valid = User.roles.include?(params[:user][:role])
    message = 'Invalid or missing user role. only accept <athlete> or <committee>'
    response, code = UserPresenter.new(nil, nil, 422).generic_error(message)

    render json: response, status: code unless is_valid
  end
end
