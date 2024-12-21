<template>
  <div class="app-container">
    <!-- タイトル -->
    <header class="app-header">
      <h1>メールコンテンツ自動生成くん</h1>
    </header>

    <main class="app-main">
      <!-- プレビュー表示エリア -->
      <section class="preview-section">
        <h2>プレビュー表示</h2>
        <div class="preview-content" v-html="previewHtml"></div>
      </section>

      <!-- メールコンテンツ入力エリア -->
      <section class="text-input-section">
        <h2>メールコンテンツ入力</h2>
        <textarea
          v-model="text"
          class="text-input"
          placeholder="メール内容を入力してください"
        ></textarea>
        <button @click="convertToHtml" class="action-button">適用</button>
      </section>

      <!-- 修正内容会話形式エリア -->
      <section class="chat-section">
        <h2>AIとの会話で修正</h2>
        <div class="chat-display">
          <div v-for="(message, index) in chatMessages" :key="index" class="chat-message">
            <div :class="message.sender === 'user' ? 'user-message-container' : 'ai-message-container'">
              <span :class="message.sender === 'user' ? 'user-name' : 'ai-name'">
                {{ message.sender === 'user' ? 'ユーザー' : 'AIチャットくん' }}
              </span>
              <div :class="message.sender === 'user' ? 'user-message' : 'ai-message'">
                <p>{{ message.text }}</p>
              </div>
            </div>
          </div>
        </div>
        <div class="chat-input">
          <textarea
            v-model="userMessage"
            class="text-input"
            placeholder="修正指示を入力してください"
          ></textarea>
          <button @click="sendChatMessage" class="action-button">送信</button>
        </div>
      </section>

      <!-- HTMLコードエリア -->
      <section class="html-section">
        <h2>HTMLコード</h2>
        <pre class="html-output">{{ previewHtml }}</pre>
      </section>

    </main>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from "vue";

export default defineComponent({
  setup() {
    const text = ref<string>("");
    const previewHtml = ref<string>("");
    const userMessage = ref<string>("");
    const chatMessages = ref<{ sender: string; text: string }[]>([]);

    // デフォルトメッセージの設定
    onMounted(() => {
      chatMessages.value.push({
        sender: "ai",
        text: "修正内容を入力してください。",
      });
    });

    const convertToHtml = async () => {
      const response = await fetch("http://localhost:3000/mails/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: text.value }),
      });

      if (response.ok) {
        const data = await response.json();
        previewHtml.value = data.html;
      }
    };

    const sendChatMessage = async () => {
      if (!userMessage.value.trim()) return;

      // Add user message to chat
      chatMessages.value.push({ sender: "user", text: userMessage.value });

      // Simulate AI response
      chatMessages.value.push({
        sender: "ai",
        text: `修正内容を反映しました: 「${userMessage.value}」`,
      });

      // Clear user input
      userMessage.value = "";
    };

    return { text, previewHtml, userMessage, chatMessages, convertToHtml, sendChatMessage };
  },
});
</script>

<style scoped>
/* 全体レイアウト */
.app-container {
  font-family: 'Helvetica Neue', Arial, sans-serif;
  color: #333;
  max-width: 900px;
  margin: 2rem auto;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.app-header {
  text-align: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: #007aff;
  border-bottom: 2px solid #ddd;
  padding-bottom: 1rem;
}

/* メールコンテンツ入力エリア */
.text-input-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.text-input {
  width: 100%;
  height: 100px;
  padding: 0.75rem;
  font-size: 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  resize: vertical;
}

.action-button {
  margin-top: 0.5rem;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  color: #fff;
  background-color: #007aff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.action-button:hover {
  background-color: #005bb5;
}

/* プレビュー表示エリア */
.preview-section,
.html-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.preview-content,
.html-output {
  background-color: #fff;
  padding: 1rem;
  border-radius: 8px;
  border: 1px solid #eee;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
}

.html-output {
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  white-space: pre-wrap;
  word-break: break-word;
  overflow-x: auto;
}

/* 修正内容会話形式エリア */
.chat-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.chat-display {
  max-height: 1000px;
  height: 500px;
  overflow-y: auto;
  margin-bottom: 1rem;
  padding: 0.5rem;
  background-color: #fff;
  border: 1px solid #eee;
  border-radius: 8px;
}

.chat-message {
  margin-bottom: 1rem;
}

.user-message-container,
.ai-message-container {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.user-name {
  text-align: right;
  font-weight: bold;
  color: #007aff;
}

.ai-name {
  text-align: left;
  font-weight: bold;
  color: #333;
}

.user-message {
  text-align: right;
  color: #007aff;
  background-color: #e6f7ff;
  padding: 0.5rem;
  border-radius: 8px;
  display: inline-block;
}

.ai-message {
  text-align: left;
  color: #333;
  background-color: #f1f1f1;
  padding: 0.5rem;
  border-radius: 8px;
  display: inline-block;
}

.chat-input {
  display: flex;
  gap: 0.5rem;
}
</style>
