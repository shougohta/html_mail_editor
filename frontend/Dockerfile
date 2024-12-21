FROM node:18

# 作業ディレクトリを設定
WORKDIR /app

# 必要なファイルをコピーしてインストール
COPY package.json yarn.lock ./
RUN yarn install

# ソースコードをコピー
COPY . .

# ポートを公開
EXPOSE 8080

# 開発サーバーを起動
CMD ["yarn", "serve"]
