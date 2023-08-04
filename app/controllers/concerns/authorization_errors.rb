module AuthorizationErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from JWT::DecodeError, with: :jwt_decode_error
    rescue_from JWT::ExpiredSignature, with: :jwt_expired_error
    rescue_from JWT::InvalidIssuerError, with: :jwt_invalid_issuer_error
    rescue_from JWT::InvalidIatError, with: :jwt_invalid_issue_at_error
    rescue_from JWT::VerificationError, with: :jwt_verification_error
  end

  protected

  def user_not_authorized
    render json: { status: { code: 403, message: 'You are not authorized to perform this action.' } }, status: 403
  end

  def jwt_decode_error
    render json: { status: { code: 401, message: 'A token must be passed.' } }, status: 401
  end

  def jwt_expired_error
    render json: { status: { code: 403, message: 'The token has expired.' } }, status: 403
  end

  def jwt_invalid_issuer_error
    render json: { status: { code: 403, message: 'The token does not have a valid issuer.' } }, status: 403
  end

  def jwt_invalid_issue_at_error
    render json: { status: { code: 403, message: 'The token does not have a valid "issued at" time.' } }, status: 403
  end

  def jwt_verification_error
    render json: { status: { code: 403, message: 'The token signature is invalid.' } }, status: 403
  end
end
