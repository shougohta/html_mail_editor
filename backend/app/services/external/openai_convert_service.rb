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

      context = "テキストをHTML形式のメールに変換してください。表や記号、デザインを入れてください。"


      params = ["クール", "シンプル", "わかりやすい", "鮮やか"]
      prompt = params.join("、") + "なデザインにしてください"

      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: context },
            { role: "system", content: prompt },
            { role: "user", content: text }
          ]
        }
      )

      html_content = response.dig("choices", 0, "message", "content")
      html_content
    end
  end
end

