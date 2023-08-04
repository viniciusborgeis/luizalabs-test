class UserGateway
  def login(email, password)
    user = User.find_for_database_authentication(email:)
    return nil unless user
    return nil unless user.valid_password?(password)

    user
  end

  def logout(token_hash)
    user = User.find_by(jti: token_hash['jti'])
    return unless user

    user
  end

  def sign_up(user_params)
    user = User.new(user_params)

    user.save ? user : user.errors
  end
end
