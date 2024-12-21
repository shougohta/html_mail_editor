module External
  # openaiのAPIを使用してテキストをHTMLに変換するサービス
  class OpenaiConvertService
    def initialize(text)
      @text = text
    end

    attr_reader :text

    def execute
      api_key = Rails.application.credentials.chatgpt_api_key
      client = OpenAI::Client.new(access_token: api_key)

      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "Convert the following text into HTML format for an email." },
            { role: "user", content: text }
          ]
        }
      )

      html_content = response.dig("choices", 0, "message", "content")
      html_content
    end
  end
end

