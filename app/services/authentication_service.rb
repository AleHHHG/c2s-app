# frozen_string_literal: true

class AuthenticationService
  AUTHENTICATION_SERVICE_URL = ENV['AUTHENTICATION_SERVICE_URL']
  class << self

    def create(params)
      attrs = build_params(params)
      attrs[:user].merge!(name: params[:name])
      response = RestClient.post(
        "#{AUTHENTICATION_SERVICE_URL}/users",
        attrs,
        { content_type: :json, accept: :json }
      )
      true
    rescue
      false
    end

    def login(params)
      response = RestClient.post(
        "#{AUTHENTICATION_SERVICE_URL}/users/sign_in",
        build_params(params),
        { content_type: :json, accept: :json }
      )
      JSON.parse(response.body).deep_symbolize_keys
    rescue
      return {}
    end

    private

    def build_params(params)
      {
        user: {
          email: params[:email],
          password: params[:password]
        }
      }
    end
  end
end
