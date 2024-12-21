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

      <!-- HTMLコードエリア -->
      <section class="html-section">
        <h2>HTMLコード</h2>
        <pre class="html-output">{{ previewHtml }}</pre>
      </section>

      <!-- 文言エリア -->
      <section class="text-section">
        <div class="text-inputs">
          <div>
            <h3>メールコンテンツ入力</h3>
            <textarea
              v-model="text"
              class="text-input"
              placeholder="メール内容を入力してください"
            ></textarea>
            <button @click="convertToHtml" class="action-button">HTML生成</button>
          </div>

          <div>
            <h3>修正内容入力</h3>
            <textarea
              v-model="editText"
              class="text-input"
              placeholder="修正内容を記載してください"
            ></textarea>
            <button @click="submitEdit" class="action-button">修正内容を送信</button>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";

export default defineComponent({
  setup() {
    const text = ref<string>("");
    const previewHtml = ref<string>("");
    const editText = ref<string>("");

    const convertToHtml = async () => {
      const response = await fetch("http://localhost:3000/mails/convert", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: text.value }),
      });

      if (response.ok) {
        const data = await response.json();
        previewHtml.value = data.html;
      }
    };

    const submitEdit = () => {
      alert(`修正内容: ${editText.value}`); // 仮実装
    };

    return { text, previewHtml, editText, convertToHtml, submitEdit };
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

.app-main {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

/* プレビュー表示エリア */
.preview-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.preview-content {
  background-color: #fff;
  padding: 1rem;
  border-radius: 8px;
  border: 1px solid #eee;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
}

/* HTMLコードエリア */
.html-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.html-output {
  background-color: #fff;
  padding: 1rem;
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  border-radius: 8px;
  border: 1px solid #eee;
  white-space: pre-wrap;
  word-break: break-word;
  overflow-x: auto;
}

/* 文言エリア */
.text-section {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  background-color: #f9f9f9;
}

.text-inputs {
  display: flex;
  flex-direction: column;
  gap: 1rem;
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
</style>
