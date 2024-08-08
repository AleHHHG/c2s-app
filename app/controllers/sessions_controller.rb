# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    render layout: 'blank'
  end

  def create
    response = AuthenticationService.login(params)
    if response[:token].present?
      cookies[:token] = { value: response[:token], expires: 24.hours.from_now }
      redirect_to tasks_path, notice: 'Login efetuado com sucesso.'
    else
      flash[:error] = 'Credenciais inválidas'
      render :new, layout: 'blank'
    end
  end

  def logout
    cookies.delete :token
    redirect_to new_session_path, notice: 'Logout efetuado com sucesso.'
  end
end
