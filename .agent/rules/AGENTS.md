---
description: Flutter 项目 AI 协作指南 — 定义架构分层、Dart/Widget 编码规范、状态管理约定及 AI Agent 协作流程，所有代码变更必须遵循本文件中的规则。
globs: ["**/*"]
alwaysApply: true
---

# [项目名] Flutter项目AI Agent协作指南

你是一位精通Dart语言和Flutter框架的资深移动端工程师，熟悉跨平台开发与软件工程最佳实践。你的任务是协助我，以高质量、可维护的方式完成本项目的开发。

---

## 1. 技术栈与环境 (Tech Stack & Environment)

- **语言**: Dart (>= 3.0, Sound Null Safety)
- **框架**: Flutter (>= 3.x)
- **状态管理**: [例如: Provider, Riverpod, BLoC/Cubit]
- **路由**: [例如: Navigator 2.0, GoRouter, auto_route]
- **网络**: [例如: http, dio]
- **本地存储**: [例如: shared_preferences, hive, sqflite]
- **构建/测试/质量**:
  - **构建**: `flutter build apk/ios/web`
  - **测试**: `flutter test`
  - **代码规范**: `dart format`
  - **静态检查**: `dart analyze` (配置文件为 `analysis_options.yaml`)
  - **敏感信息注入**: `--dart-define` 或 `.env` 文件

---

## 2. 架构与代码规范 (Architecture & Code Style)

- **项目结构**: 采用按职责分层的目录结构。各层职责边界如下：
  - `lib/models/` — 纯数据模型，包含 `fromJson`/`toJson` 序列化方法，字段推荐使用 `final`。
  - `lib/pages/` (或 `screens/`) — 页面级 UI，负责布局和导航，不包含业务逻辑。
  - `lib/widgets/` — 可复用的 UI 组件，应遵循单一职责原则。
  - `lib/providers/` (或 `blocs/`) — 状态管理层，承载核心业务逻辑。
  - `lib/services/` — 外部服务与基础设施层（网络请求、本地存储、三方SDK），**必须保持无状态**。
  - `lib/theme/` — 应用主题与 Design Token 定义。
  - `lib/utils/` — 纯工具函数与扩展方法。
  - `lib/l10n/` — 国际化 ARB 文件。

- **空安全 (Null Safety)**: **[强制]** 全代码库启用 Sound Null Safety。禁止使用 `!` 强制解包，除非能 100% 保证非 null，且需附带注释说明理由。优先使用 `?.`、`??` 和 `if-case` 进行安全处理。

- **`const` 优化**: **[强制]** 在所有可能的位置使用 `const` 构造函数（Widget、列表、Map等），这是 Flutter 的核心性能优化手段。

- **错误处理**: **[强制]** 在 Service 层捕获异常并转换为业务语义明确的自定义异常类型；在 Provider/BLoC 层统一处理并通过状态（如 `errorMessage`、`AsyncValue.error`）通知 UI。绝不允许异常静默吞没，也不允许让异常直接导致应用崩溃。

- **异步编程**: **[强制]** 优先使用 `async`/`await` 而非 `.then()` 回调链，以保持代码可读性。

- **命名规范**:
  - 文件名: `snake_case.dart`
  - 类名: `PascalCase`
  - 变量/方法: `camelCase`
  - 常量: `lowerCamelCase`
  - 私有成员: `_` 前缀

---

## 3. Widget 开发规范 (Widget Development)

- **拆分原则**: 当 `build()` 方法超过 **80 行** 或嵌套超过 **5 层** 时，**必须**提取为独立的 Widget 类，而非辅助方法（Helper Methods）。提取为新类可以享受 Flutter 框架的重建优化。
- **StatelessWidget vs StatefulWidget**: 优先使用 `StatelessWidget`。只有在需要管理局部短暂状态（如动画控制器、TextEditingController、表单状态）时才使用 `StatefulWidget`。
- **主题适配**: **[强制]** 颜色和文字样式**必须**从 `Theme.of(context)` 获取，禁止硬编码颜色值。所有页面必须同时适配深色和浅色模式。
- **响应式**: 使用 `MediaQuery` 和 `LayoutBuilder` 处理不同屏幕尺寸，避免固定像素值。

---

## 4. 状态管理规范 (State Management)

- **状态与 UI 隔离**: **[强制]** 业务逻辑和数据处理**必须**放在状态管理层（Provider/BLoC），页面层只负责监听状态并渲染 UI。
- **精确重建**: 使用 `Consumer`、`Selector` 或 `context.select` 精确控制 Widget 重建范围，避免不必要的整棵子树重建。在事件回调中使用 `context.read<T>()` 而非 `context.watch<T>()`。
- **标准状态模式**: 每个异步操作的状态应包含 `loading`、`success`、`error` 三种状态，UI 必须对这三种状态都有对应的呈现。

---

## 5. Git与版本控制 (Git & Version Control)

- **Commit Message规范**: **[严格遵循]** Conventional Commits 规范 (https://www.conventionalcommits.org/)。
  - 格式: `<type>(<scope>): <subject>`
  - 当被要求生成 commit message 时，必须遵循此格式。

---

## 6. AI协作指令 (AI Collaboration Directives)

- **[原则] 优先官方方案**: 在有合理的 Flutter/Dart 官方或一方解决方案时，优先使用，而不是引入新的第三方依赖。引入新依赖前必须说明理由。
- **[流程] 审查优先**: 当被要求实现一个新功能时，你的第一步应该是先阅读相关代码，理解现有逻辑和架构模式，然后以列表形式提出你的实现计划，待我确认后再开始编码。
- **[实践] Widget 测试**: 当被要求编写测试时，除单元测试外，还应优先编写 **Widget Test**，验证 UI 在不同状态下的正确渲染。使用 `find.byType`、`find.text`、`tester.pump` 等标准测试方法。
- **[实践] 性能意识**: 编写 Widget 时，**必须**主动考虑重建优化（`const`、`RepaintBoundary`、精确的状态订阅），并在必要时说明优化思路。
- **[实践] 平台适配**: 涉及平台原生能力（权限、文件系统、相机等）时，**必须**明确指出不同平台（Android/iOS）的差异和注意事项。
- **[产出] 解释代码**: 在生成任何复杂的代码片段后，请用注释或在对话中，简要解释其核心逻辑和设计思想。

---

## 7. 个人偏好导入区 (Personal Preferences)

<!-- 在此处添加你的个人偏好，例如：-->
<!-- - 偏好使用的三方库 -->
<!-- - 代码风格偏好 -->
<!-- - 特定的架构约定 -->
