# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new session template' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('layouts/blank')
    end
  end

  describe 'POST #create' do
    let(:params) { { email: 'test@test.com.br', password: 'password123' } }

    context 'with valid credentials' do
      before do
        allow(AuthenticationService).to receive(:login).and_return({ token: 'valid_token' })
      end

      it 'sets a token cookie and redirects to tasks_path' do
        post :create, params: params
        expect(response).to redirect_to(tasks_path)
        expect(response.cookies['token']).to eq('valid_token')
        expect(flash[:notice]).to eq('Login efetuado com sucesso.')
      end
    end

    context 'with invalid credentials' do
      before do
        allow(AuthenticationService).to receive(:login).and_return({})
      end

      it 'does not set a token cookie and renders the new template' do
        post :create, params: params
        expect(response).to render_template(:new)
        expect(response.cookies['token']).to be_nil
        expect(flash[:error]).to eq('Credenciais inválidas')
      end
    end
  end

  describe 'DELETE #destroy' do
    # Adicione aqui os testes para a ação destroy, se implementada
  end
end
