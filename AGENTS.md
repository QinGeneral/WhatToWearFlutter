<!-- SKILLS_INDEX_START -->
# Agent Skills Index

> [!IMPORTANT]
> **Prefer retrieval-led reasoning over pre-training-led reasoning.**
> Before writing any code, you MUST CHECK if a relevant skill exists in the index below.
> If a skill matches your task, READ the file using `view_file`.

## **Rule Zero: Zero-Trust Engineering**

- **Skill Authority:** Loaded skills always override existing code patterns.
- **Audit Before Write:** Audit every file write against the `common/feedback-reporter` skill.

- **[common/best-practices]**: 🚨 Universal principles for clean, maintainable, and robust code across all environments. (triggers: solid, kiss, dry, yagni, naming, conventions)
- **[common/code-review]**: Standards for high-quality, persona-driven code reviews. (triggers: review, pr, critique, analyze code)
- **[common/context-optimization]**: Techniques to maximize context window efficiency, reduce latency, and prevent 'lost in middle' issues through strategic masking and compaction. (triggers: *.log, chat-history.json, reduce tokens, optimize context, summarize history, clear output)
- **[common/debugging]**: Systematic troubleshooting using the Scientific Method (Observe, Hypothesize, Experiment, Fix). (triggers: debug, fix bug, crash, error, exception, troubleshooting)
- **[common/documentation]**: Essential rules for code comments, READMEs, and technical documentation. (triggers: comment, docstring, readme, documentation)
- **[common/feedback-reporter]**: 🚨 CRITICAL - Before ANY file write, audit loaded skills for violations. Auto-report via feedback command. (triggers: **/*, write, edit, create, generate, skill, violation)
- **[common/git-collaboration]**: 🚨 Universal standards for version control, branching, and team collaboration. (triggers: commit, branch, merge, pull-request, git)
- **[common/mobile-animation]**: Motion design principles for mobile apps. Covers timing curves, transitions, gestures, and performance-conscious animations. (triggers: **/*_page.dart, **/*_screen.dart, **/*.swift, **/*Activity.kt, **/*Screen.tsx, Animation, AnimationController, Animated, MotionLayout, transition, gesture)
- **[common/mobile-ux-core]**: 🚨 Universal mobile UX principles for touch-first interfaces. Enforces touch targets, safe areas, and mobile-specific interaction patterns. (triggers: **/*_page.dart, **/*_screen.dart, **/*_view.dart, **/*.swift, **/*Activity.kt, **/*Screen.tsx, mobile, responsive, SafeArea, touch, gesture, viewport)
- **[common/performance-engineering]**: Universal standards for high-performance software development across all frameworks. (triggers: performance, optimize, profile, scalability)
- **[common/product-requirements]**: 🚨 Expert process for gathering requirements and drafting PRDs (Iterative Discovery). (triggers: PRD.md, specs/*.md, create prd, draft requirements, new feature spec)
- **[common/security-standards]**: 🚨 Universal security protocols for building safe and resilient software. (triggers: security, encrypt, authenticate, authorize)
- **[common/system-design]**: 🚨 Universal architectural standards for building robust, scalable, and maintainable systems. (triggers: architecture, design, system, scalability)
- **[common/tdd]**: Enforces Test-Driven Development (Red-Green-Refactor) for rigorous code quality.
- **[flutter/cicd]**: Continuous Integration and Deployment standards for Flutter apps. (triggers: .github/workflows/**.yml, fastlane/**, android/fastlane/**, ios/fastlane/**, ci, cd, pipeline, build, deploy, release, action, workflow)
- **[flutter/error-handling]**: Functional error handling using Dartz and Either. (triggers: lib/domain/**, lib/infrastructure/**, Either, fold, Left, Right, Failure, dartz)
- **[flutter/feature-based-clean-architecture]**: 🚨 Standards for organizing code by feature at the root level to improve scalability and maintainability. (triggers: lib/features/**, feature, domain, infrastructure, application, presentation, modular)
- **[flutter/flutter-design-system]**: 🚨 Enforce strict Design Language System (DLS) adherence. Prevents hardcoded colors, spacing, and typography. Detects and uses project tokens. (triggers: **/theme/**, **/*_theme.dart, **/*_colors.dart, **/*_dls/**, **/foundation/**, ThemeData, ColorScheme, AppColors, VColors, VSpacing, AppTheme, design token)
- **[flutter/flutter-navigation]**: Flutter navigation patterns including go_router, deep linking, and named routes for Flutter apps. (triggers: **/*_route.dart, **/*_router.dart, **/main.dart, Navigator, GoRouter, routes, deep link, go_router, AutoRoute)
- **[flutter/flutter-notifications]**: Push notifications and local notifications for Flutter using Firebase Cloud Messaging and flutter_local_notifications. (triggers: **/*notification*.dart, **/main.dart, FirebaseMessaging, FlutterLocalNotificationsPlugin, FCM, notification, push)
- **[flutter/idiomatic-flutter]**: Modern layout and widget composition standards. (triggers: lib/presentation/**/*.dart, context.mounted, SizedBox, Gap, composition, shrink)
- **[flutter/layer-based-clean-architecture]**: 🚨 Standards for separation of concerns, layer dependency rules, and DDD in Flutter. (triggers: lib/domain/**, lib/infrastructure/**, lib/application/**, domain, infrastructure, application, presentation, layers, dto, mapper)
- **[flutter/performance]**: Optimization standards for rebuilds and memory. (triggers: lib/presentation/**, pubspec.yaml, const, buildWhen, ListView.builder, Isolate, RepaintBoundary)
- **[flutter/security]**: 🚨 Security standards for Flutter applications based on OWASP Mobile. (triggers: lib/infrastructure/**, pubspec.yaml, secure_storage, obfuscate, jailbreak, pinning, PII, OWASP)
- **[flutter/testing]**: 🚨 Core standards for unit, widget, and integration testing in Flutter.
- **[flutter/widgets]**: Principles for maintainable UI components. (triggers: **_page.dart, **_screen.dart, **/widgets/**, StatelessWidget, const, Theme, ListView)
- **[dart/best-practices]**: General purity standards for Dart development. (triggers: **/*.dart, import, final, const, var, global)
- **[dart/language]**: 🚨 Modern Dart standards (3.x+) including null safety and patterns. (triggers: **/*.dart, sealed, record, switch, pattern, extension, final, late, async, await)
- **[dart/tooling]**: Standards for analysis, linting, formatting, and automation. (triggers: analysis_options.yaml, pubspec.yaml, build.yaml, analysis_options, lints, format, build_runner, cider, husky)
- **[common/best-practices]**: 🚨 Universal principles for clean, maintainable, and robust code across all environments. (triggers: solid, kiss, dry, yagni, naming, conventions)
- **[common/code-review]**: Standards for high-quality, persona-driven code reviews. (triggers: review, pr, critique, analyze code)
- **[common/context-optimization]**: Techniques to maximize context window efficiency, reduce latency, and prevent 'lost in middle' issues through strategic masking and compaction. (triggers: *.log, chat-history.json, reduce tokens, optimize context, summarize history, clear output)
- **[common/debugging]**: Systematic troubleshooting using the Scientific Method (Observe, Hypothesize, Experiment, Fix). (triggers: debug, fix bug, crash, error, exception, troubleshooting)
- **[common/documentation]**: Essential rules for code comments, READMEs, and technical documentation. (triggers: comment, docstring, readme, documentation)
- **[common/feedback-reporter]**: 🚨 CRITICAL - Before ANY file write, audit loaded skills for violations. Auto-report via feedback command. (triggers: **/*, write, edit, create, generate, skill, violation)
- **[common/git-collaboration]**: 🚨 Universal standards for version control, branching, and team collaboration. (triggers: commit, branch, merge, pull-request, git)
- **[common/mobile-animation]**: Motion design principles for mobile apps. Covers timing curves, transitions, gestures, and performance-conscious animations. (triggers: **/*_page.dart, **/*_screen.dart, **/*.swift, **/*Activity.kt, **/*Screen.tsx, Animation, AnimationController, Animated, MotionLayout, transition, gesture)
- **[common/mobile-ux-core]**: 🚨 Universal mobile UX principles for touch-first interfaces. Enforces touch targets, safe areas, and mobile-specific interaction patterns. (triggers: **/*_page.dart, **/*_screen.dart, **/*_view.dart, **/*.swift, **/*Activity.kt, **/*Screen.tsx, mobile, responsive, SafeArea, touch, gesture, viewport)
- **[common/performance-engineering]**: Universal standards for high-performance software development across all frameworks. (triggers: performance, optimize, profile, scalability)
- **[common/product-requirements]**: 🚨 Expert process for gathering requirements and drafting PRDs (Iterative Discovery). (triggers: PRD.md, specs/*.md, create prd, draft requirements, new feature spec)
- **[common/security-standards]**: 🚨 Universal security protocols for building safe and resilient software. (triggers: security, encrypt, authenticate, authorize)
- **[common/system-design]**: 🚨 Universal architectural standards for building robust, scalable, and maintainable systems. (triggers: architecture, design, system, scalability)
- **[common/tdd]**: Enforces Test-Driven Development (Red-Green-Refactor) for rigorous code quality.

<!-- SKILLS_INDEX_END -->
