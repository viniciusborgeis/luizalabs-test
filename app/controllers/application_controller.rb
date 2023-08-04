class ApplicationController < ActionController::API
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  def user_not_authorized
    render json: { status: { code: 403, message: 'You are not authorized to perform this action.' } }, status: 403
  end
end
