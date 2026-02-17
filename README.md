# What to Wear (Flutter版)

这是一个基于 Flutter 构建的智能衣橱助手，旨在根据你的衣橱库存和当地天气情况，为你提供每日穿搭建议。本项目是原有 "What to Wear" 概念的 Flutter 实现版本，利用 Google Gemini AI 提供智能化的穿搭推荐。

## ✨ 功能特性

- **🤖 AI 智能推荐**：基于当地天气和你特有的衣物，由 Google Gemini 提供个性化的每日穿搭建议。
- **🌤️ 实时天气**：自动获取你所在位置的当前天气状况，确保穿搭舒适得体。
- **👕 衣橱管理**：轻松添加、编辑和分类管理你的衣物（上装、下装、鞋履、配饰）。
- **👗 穿搭可视化**：利用 AI 生成推荐穿搭的视觉预览效果。
- **🌗 深色/浅色模式**：现代化的自适应 UI，支持深色和浅色主题切换。
- **📤 分享你的穿搭**：生成并分享你的每日穿搭卡片。

## 🛠️ 技术栈

- **框架**: [Flutter](https://flutter.dev/)
- **状态管理**: [Provider](https://pub.dev/packages/provider)
- **AI 集成**: [google_generative_ai](https://pub.dev/packages/google_generative_ai) (Gemini API)
- **定位服务**: [geolocator](https://pub.dev/packages/geolocator) & [geocoding](https://pub.dev/packages/geocoding)
- **本地存储**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **网络请求**: [http](https://pub.dev/packages/http)
- **UI 组件**: Material Design 3

## 🚀 快速开始

### 前置要求

- 安装 [Flutter SDK](https://docs.flutter.dev/get-started/install)。
- 一个有效的 [Gemini API Key](https://aistudio.google.com/)。

### 安装步骤

1.  **克隆仓库**：
    ```bash
    git clone https://github.com/your-username/what_to_wear_flutter.git
    cd what_to_wear_flutter
    ```

2.  **安装依赖**：
    ```bash
    flutter pub get
    ```

### 运行应用

运行应用时，你需要通过 `--dart-define` 标志传入你的 Gemini API Key。这样做可以避免将密钥硬编码在源代码中。

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

请将 `YOUR_GEMINI_API_KEY` 替换为你实际的 API Key。

## 📂 项目结构

- `lib/models`: 数据模型（衣物项、天气等）。
- `lib/pages`: 应用页面（首页、衣橱、添加衣物等）。
- `lib/providers`: 状态管理逻辑（WeatherProvider, WardrobeProvider, RecommendationProvider）。
- `lib/services`: API 调用和外部集成服务层（WeatherService, ImageAnalysisService）。
- `lib/widgets`: 可复用的 UI 组件。
- `lib/theme`: 应用主题定义。

## 🤝 贡献

欢迎提交 Pull Request 来贡献代码！
