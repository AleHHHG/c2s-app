# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService, type: :service do
  describe '.login', :vcr do
    let(:email) { 'alessandro.guedess@gmail.com' }
    let(:valid_params) { { email: email, password: '123456' } }
    let(:invalid_params) { { email: 'teste@teste.com', password: '123456' } }
    let(:singup_params) { { email: 'alessandro@teste.com', password: '123456' } }

    describe '.create' do
      context 'when the request is successful' do
        it 'returns a true' do
          VCR.use_cassette('authentication_service_create_success') do
            result = AuthenticationService.create(singup_params)
            expect(result).to eq(true)
          end
        end
      end

      context 'when the request fails' do
        it 'returns a false' do
          VCR.use_cassette('authentication_service_create_failure') do
            result = AuthenticationService.create(singup_params)
            expect(result).to eq(false)
          end
        end
      end
    end

    describe '.login' do
      context 'when the request is successful' do
        it 'returns a hash with the response body' do
          VCR.use_cassette('authentication_service_login_success') do
            result = AuthenticationService.login(valid_params)
            expect(result).to be_a(Hash)
            expect(result).to have_key(:token)
          end
        end
      end

      context 'when the request fails' do
        it 'returns an empty hash' do
          VCR.use_cassette('authentication_service_login_failure') do
            # Simulate a failure scenario
            # Depending on your setup, this might involve configuring the remote service to fail
            result = AuthenticationService.login(invalid_params)
            expect(result).to eq({})
          end
        end
      end
    end
  end
end
