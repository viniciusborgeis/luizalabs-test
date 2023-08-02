# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json
  
  before_action :check_valid_type, only: [:create]

  def create
    user = SignupUsecase.new(sign_up_params).execute

    if user.is_a?(User)
      sign_in(user)
      render json: UserPresenter.new(user, 200).signup_success, status: :ok
    else
      render json: UserPresenter.new(user, 422).signup_failed, status: :unprocessable_entity
    end
  end

  private

  def check_valid_type
    is_valid = User.roles.include?(params[:user][:role])

    render json: UserPresenter.new(nil, 422).generic_error('Invalid or missing user role.'), status: :unprocessable_entity unless is_valid
  end

end
