# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def link_icon(url, css_class, icon, text)
    "<a href='#{url}' class='#{css_class}'><i class='#{icon}'></i> #{text} </a>".html_safe
  end

  def back_button
    '<a href="javascript:;" onclick="history.back()" class="btn btn-light"><i class="fa-regular fa-circle-left"></i> Voltar</a>'.html_safe
  end
end