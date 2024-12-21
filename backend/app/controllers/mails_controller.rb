require 'openai'

class MailsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def convert
    # client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    # response = client.chat(
    #   parameters: {
    #     model: "gpt-4",
    #     messages: [
    #       { role: "system", content: "Convert the following text into HTML format for an email." },
    #       { role: "user", content: params[:text] }
    #     ]
    #   }
    # )

    # html_content = response.dig("choices", 0, "message", "content")
    html_content = "test"
    render json: { html: html_content }
  rescue StandardError => e
    render json: { error: e.message }, status: 500
  end
end
