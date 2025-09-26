# ✨ reWriteAI

**reWriteAI** is a lightweight macOS menu bar app that helps you **rewrite and polish text with AI**.  
Perfect for quick message polishing, and short copy that needs a professional touch.  

Built with **SwiftUI** and powered by the **OpenAI API**.

---

## 🚀 Features

- 🖥️ Runs from your macOS **menu bar**  
- 📝 Rewrite any text in a simple dialog box  
- 🤖 Powered by OpenAI (`gpt-5`, `gpt-5-nano`, `gpt-mini`)  
- ⚙️ Configurable system prompt (set your preferred rewriting style)  
- 🔑 Easy **API Key** setup via Settings  
- 📋 **Copy to Clipboard** button for results  
- 🔓 100% open source  

---

## 📦 Installation

### Option 1: Download DMG (recommended)
👉 [Releases Page](https://github.com/yourname/rewriteai/releases) (coming soon)

1. Download the latest `.dmg`  
2. Drag **reWriteAI.app** into your **Applications** folder  
3. Launch from Spotlight or menu bar  

### Option 2: Build from source
1. Clone the repo:
   ```bash
   git clone https://github.com/yourname/rewriteai.git
   cd rewriteai
   ```
2. Open in Xcode:
   ```bash
   open reWriteAI.xcodeproj
   ```
3. Press **Run** (`⌘R`)  

---

## 🔑 API Key Setup

reWriteAI uses the [OpenAI API](https://platform.openai.com/).  
You’ll need an API key to use it.

- In the app, open **Settings → API Key**  
- Paste your OpenAI key (`sk-...`)  
- Saved securely in AppStorage  

Alternatively, you can set it as an **environment variable**:

```bash
export OPENAI_API_KEY="sk-yourkey"
```

---

## ⚙️ Configuration

In **Settings**, you can adjust:

- **API Key** (required)  
- **System Prompt** (tone/style of rewriting, e.g. “Polish this for a professional restaurant menu”)  
- **Model**: `gpt-5`, `gpt-5-nano`, or `gpt-mini`  
- **Max Completion Tokens** (optional, defaults to 2000)  

---

## 🛠️ Development

Requirements:
- macOS 14+  
- Xcode 15+  
- Swift 5.9+  

---

## 🤝 Contributing

We welcome contributions! 🎉  

- Fork the repo  
- Create a feature branch (`git checkout -b feature/your-feature`)  
- Commit changes (`git commit -m "Add feature"`)  
- Push and open a Pull Request  

---

## 📜 License

MIT License © 2025  
