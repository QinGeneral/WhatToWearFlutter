# What to Wear Flutter - AGENTS.md

本文档旨在为开发这一项目的 AI Agent 和人类开发者提供指导。它包含项目架构、技术栈细节、编码规范以及工作流程，确保项目的一致性和高质量维护。

## 📖 项目概述

**What to Wear (Flutter)** 是一个智能衣橱管理与穿搭推荐应用。
- **核心目标**: 帮助用户管理衣物，并根据当地天气提供 AI 驱动的每日穿搭建议。
- **技术基础**: Flutter (MVVM 架构), Google Gemini AI, Material 3 Design。

## 🏗️ 项目架构与目录结构

本项目采用 **MVVM (Model-View-ViewModel)** 架构模式，其中 `Provider` 充当 ViewModel 层。

- **`lib/models`**: 数据模型。
  - 应包含 `fromJson` / `toJson` 方法以便序列化。
  - 推荐使用 `final` 字段。
- **`lib/providers`**: 状态管理与业务逻辑。
  - `WeatherProvider`: 处理位置获取和天气数据请求。
  - `WardrobeProvider`: 管理衣物的增删改查（CRUD）及本地存储同步。
  - `RecommendationProvider`: 处理与 Gemini AI 的交互逻辑。
  - **规则**: 复杂的业务逻辑应放在 Provider 中，而不是 UI Widget 中。
- **`lib/pages`**: 页面级 UI。
  - 负责页面布局和导航。
  - 通过 `Consumer` 或 `context.watch` 监听状态变化。
- **`lib/services`**: 外部服务与基础设施。
  - `WeatherService`: 封装 HTTP 请求。
  - `ImageAnalysisService`: 封装 Gemini API 调用。
  - **规则**: Service 层应保持无状态，只负责数据获取和处理。
- **`lib/widgets`**: 可复用的 UI 组件。
  - 尽量拆分为小的、单一职责的 Widget。
- **`lib/theme`**: 主题配置（深色/浅色模式）。

## 🛠️ 技术栈与关键库

- **Flutter SDK**: 确保使用最新的稳定版。
- **State Management**: `provider` (^6.x)。
- **Networking**: `http`。
- **AI**: `google_generative_ai` (Gemini API)。
- **Location**: `geolocator` (获取坐标), `geocoding` (坐标转地址)。
- **Local Storage**: `shared_preferences` (简单的键值存储), `image_picker` (图片选择)。
- **Utils**: `intl` (日期格式化), `uuid` (生成唯一 ID)。

## 📝 编码规范

### Dart & Flutter
- **类型安全**: 始终显式声明返回类型和参数类型。
- **Const**: 在可能的情况下，始终使用 `const` 构造函数以优化性能。
- **Async/Await**: 优先使用 `async`/`await` 而非 `then` 回调，以提高代码可读性。
- **Widget 拆分**: 当 `build` 方法过长或嵌套过深时，提取为独立的 Widget 类，而不是辅助方法（Helper Methods）。
- **资源管理**: 图片资源应放在 `assets/images/` 下，并在 `pubspec.yaml` 中正确声明。

### 状态管理 (Provider)
- **避免不必要的重绘**: 使用 `Consumer` 或 `Selector` 精确控制重绘范围，或者使用 `context.read<T>()` 在点击事件中获取 Provider。
- **错误处理**: 在 Provider 中捕获异常，并通过状态（如 `errorMessage`）通知 UI，而不是让应用崩溃。

## 🔐 配置与安全

- **API Key**: Gemini API Key **绝对不能** 硬编码在代码中。
- **注入方式**: 使用 `--dart-define` 进行注入。
  - 运行命令: `flutter run --dart-define=GEMINI_API_KEY=your_key_here`
  - 代码访问: `const String apiKey = String.fromEnvironment('GEMINI_API_KEY');`

## 🚀 工作流程建议

1.  **添加新功能**:
    - 先定义 Model。
    - 在 Service 中添加必要的 API 方法。
    - 在 Provider 中添加状态和业务逻辑。
    - 创建或更新 Page/Widget 进行展示。
2.  **修改 UI**:
    - 优先检查 `lib/theme` 中的定义，保持设计一致性。
    - 确保同时测试深色和浅色模式。
3.  **调试**:
    - 使用 `debugPrint` 打印日志。
    - 确保处理 loading 和 error 状态。

## 🌍 多语言与本地化

- 目前代码注释和 Commit Message 推荐使用 **英文** 或 **中文**（本项目主要面向中文用户，README 已中文化）。
- UI 文本目前直接硬编码在 Widget 中，未来可考虑引入 `l10n`。
