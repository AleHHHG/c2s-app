# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    render layout: 'blank'
  end

  def create
    if AuthenticationService.create(params)
      redirect_to new_session_path, notice: 'Usuario cadastrado com sucesso'
    else
      flash[:error] = 'Não foi possivel registrar o usuário'
      render :new, layout: 'blank'
    end
  end
end
