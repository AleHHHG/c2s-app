# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  def authenticate_user!
    @current_user = current_user
    redirect_to new_session_path unless @current_user.present?
  end

  def current_user
    request.env[:current_user]
  end
end
