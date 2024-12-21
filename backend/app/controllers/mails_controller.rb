require 'openai'

class MailsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def convert
    api_key = Rails.application.credentials.chatgpt_api_key
    client = OpenAI::Client.new(access_token: api_key)

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "Convert the following text into HTML format for an email." },
          { role: "user", content: params[:text] }
        ]
      }
    )

    html_content = response.dig("choices", 0, "message", "content")
    render json: { html: html_content }
  rescue StandardError => e
    render json: { error: e.message }, status: 500
  end
end
