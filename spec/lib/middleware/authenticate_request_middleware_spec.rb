# frozen_string_literal: true

require 'rails_helper'
require 'rack/test'
require 'jwt'

RSpec.describe AuthenticateRequestMiddleware do
  include Rack::Test::Methods

  let(:app) { ->(env) { [200, {}, ["OK"]] } }
  let(:middleware) { described_class.new(app) }
  let(:secret_key) { ENV['DEVISE_JWT_SECRET_KEY'] || 'secret' }
  let(:valid_token) { JWT.encode({ user_id: 1 }, secret_key, 'HS256') }
  let(:invalid_token) { 'invalid.token' }

  def call_middleware(env)
    middleware.call(env)
  end

  it 'adds current_user to env if the token is valid' do
    env = { 'rack.input' => '', 'HTTP_COOKIE' => "token=#{valid_token}" }
    call_middleware(env)
    expect(env[:current_user]).to eq({:user_id => 1 })
  end

  it 'does not add current_user to env if the token is invalid' do
    env = { 'rack.input' => '', 'HTTP_COOKIE' => "token=#{invalid_token}" }
    call_middleware(env)
    expect(env[:current_user]).to be_nil
  end

  it 'does not add current_user to env if no token is present' do
    env = { 'rack.input' => '' }
    call_middleware(env)
    expect(env[:current_user]).to be_nil
  end

  it 'handles token decoding errors gracefully' do
    allow_any_instance_of(AuthenticateRequestMiddleware).to receive(:decoded_token).and_raise(JWT::DecodeError)
    env = { 'rack.input' => '', 'HTTP_COOKIE' => "token=#{valid_token}" }
    call_middleware(env)
    expect(env[:current_user]).to be_nil
  end
end
