class ApplicationController < ActionController::API
  include Pundit::Authorization
  include AuthorizationErrors
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
