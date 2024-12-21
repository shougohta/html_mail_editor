require 'openai'

class MailsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    html_content = ::External::OpenaiConvertService.new(params[:text]).execute
    render json: { html: html_content }
  rescue StandardError => e
    render json: { error: e.message }, status: 500
  end
end
