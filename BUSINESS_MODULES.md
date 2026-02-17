# 业务模块与特性文档 (Business Modules & Features)

## 1. 项目概述 (Project Overview)

**What to Wear (Flutter)** 是一款基于 Flutter 开发的智能衣橱助手应用。旨在通过整合用户的衣橱库存与实时天气信息，利用 Google Gemini AI 提供高度个性化的每日穿搭建议。

**核心价值**:
- **智能化**: 摆脱“今天穿什么”的决策疲劳，由 AI 提供专业搭配建议。
- **数字化**: 将实体衣橱数字化，随时随地管理衣物。
- **场景化**: 结合天气和具体场合（如通勤、约会），提供得体的穿搭方案。

## 2. 业务模块 (Business Modules)

### 2.1 衣橱管理模块 (Wardrobe Management)
负责用户衣物的数字化录入、存储、分类和检索。

- **核心实体**: `WardrobeItem` (lib/models/models.dart)
- **业务逻辑**: `WardrobeProvider` (lib/providers/wardrobe_provider.dart)
- **数据存储**: 本地文件系统 (存储图片 base64) + `StorageService` (SharedPreferences/JSON)。

**主要功能**:
- **增删改查**: 支持添加新衣物、编辑现有衣物信息、删除衣物。
- **分类管理**: 按照 `ClothingCategory` (上衣、裤子、鞋履、配饰、外套) 进行分类。
- **搜索与筛选**: 支持按名称、品牌、标签进行搜索；按分类进行筛选。
- **图片管理**:
    - **多图存储**: 支持在一个单品中存储多张图片。
    - **图片优化**: 利用 `ImageAnalysisService` 优化上传的衣物图片（去除背景、调整光线）。
    - **智能分析**: 上传图片后，利用 AI 自动识别衣物属性（颜色、材质、季节等）。

### 2.2 环境与上下文模块 (Environment & Context)
负责获取外部环境信息，为推荐决策提供数据支持。

- **核心实体**: `WeatherInfo`, `UserProfile`
- **业务逻辑**: `WeatherProvider`, `ProfileProvider`
- **基础服务**: `WeatherService` (lib/services/weather_service.dart)

**主要功能**:
- **定位服务**: 利用 `geolocator` 获取用户经纬度；利用 `geocoding` 或 Nominatim API 反向解析地理位置名称。
- **实时天气**: 集成 Open-Meteo API 获取当前气温、天气状况、湿度等信息。
- **用户画像**: 记录用户偏好（风格、忌讳颜色等）和身份标签（如学生、商务人士）。

### 2.3 智能推荐模块 (Intelligent Recommendation)
核心业务模块，负责生成穿搭方案。

- **核心实体**: `Recommendation`, `RecommendationResult`, `OutfitResult`
- **业务逻辑**: `RecommendationProvider` (lib/providers/recommendation_provider.dart)
- **AI 服务**: `AIRecommendationService` (lib/services/ai_recommendation_service.dart)
- **虚拟试穿**: `VirtualTryOnService` (lib/services/virtual_try_on_service.dart)

**推荐策略**:
1.  **规则推荐 (Rule-based)**:
    - `_createOutfit` 方法：基于当前气温和季节，从衣橱中随机抽取符合条件的单品组合（Top + Bottom + Shoes + Outerwear）。
    - 适用于离线或由于 API 限制无法使用 AI 时的兜底方案。
2.  **AI 生成推荐 (AI-Generated)**:
    - 收集用户当前场景（日期、活动、同伴、具体要求）。
    - 将简化后的衣橱数据与天气信息打包发送给 Gemini 2.0 Flash 模型。
    - 模型返回包含搭配理由、匹配度的 JSON 数据。

**主要功能**:
- **每日推荐**: 首页展示今日最佳搭配。
- **场景化推荐**: 用户输入特定场景（如“周五晚上的约会”），生成针对性方案。
- **已选/替换**: 若对推荐中的某个单品不满意，支持在同类目中进行替换。
- **收藏与历史**: 用户可收藏喜欢的搭配，系统自动记录历史推荐，支持回溯。
- **虚拟试穿 (Virtual Try-on)**:
    - 利用 `VirtualTryOnService` (Gemini 3 Pro Image Preview) 生成模特试穿效果图。
    - 基于用户实际选中的衣物图片生成逼真的上身效果。

## 3. 详细特性列表 (Detailed Features)

| 模块 | 特性名称 | 描述 | 技术实现关键点 |
| :--- | :--- | :--- | :--- |
| **衣橱** | **AI 辅助录入** | 上传图片后，自动填充颜色、材质、季节等属性。 | `ImageAnalysisService.analyzeClothingImage` |
| **衣橱** | **图片美化** | 将用户拍摄的随意照片转换为干净的平铺图 (Flat-lay)。 | `ImageAnalysisService.optimizeImage` |
| **衣橱** | **本地持久化** | 即使无网络也能查看衣橱，图片存储在应用文档目录。 | `path_provider`, 文件读写 |
| **推荐** | **天气感知** | 推荐算法自动过滤不符合当前气温的衣物（如夏天不推荐羽绒服）。 | `WeatherService`, 规则筛选逻辑 |
| **推荐** | **多方案生成** | 每次生成 1 个主推荐和 2-3 个备选方案。 | `RecommendationProvider.generateRecommendation` |
| **推荐** | **搭配理由** | AI 提供具有情感温度的中文搭配建议和理由。 | Gemini Prompt Engineering |
| **推荐** | **虚拟试穿图** | 生成塑料模特穿着指定衣物的超写实渲染图。 | `VirtualTryOnService` |
| **UI/UX** | **深色模式** | 完整适配 iOS/Android 的深色模式体验。 | Flutter `ThemeData`, `Provider` |
| **UI/UX** | **多图预览** | 查看单品详情时支持轮播预览多张细节图。 | `PageView` |

## 4. 数据模型关系图 (简述)

- **User** 1 : 1 **Wardrobe** (List<WardrobeItem>)
- **User** 1 : 1 **Preferences**
- **Recommendation** 1 : N **WardrobeItem** (Top, Bottom, Shoes, etc.)
- **Recommendation** 涉及 **WeatherInfo** 和 **Context** (场景)

此文档基于现有代码库 (`lib/models`, `lib/providers`, `lib/services`) 分析生成。
