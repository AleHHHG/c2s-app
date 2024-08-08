# frozen_string_literal: true

class AuthenticateRequestMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    token = req.cookies['token']
    if token.present? && valid_token?(token)
      env[:current_user] = decoded_token(token).deep_symbolize_keys
    end
    @app.call(env)
  end

  private

  def valid_token?(token)
    decoded_token(token).present? rescue false
  end

  def decoded_token(token)
    JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256')[0]
  end
end
