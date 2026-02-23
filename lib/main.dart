import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/features/profile/provider/profile_provider.dart';
import 'package:what_to_wear_flutter/features/profile/repository/profile_repository.dart';
import 'package:what_to_wear_flutter/features/recommendation/provider/recommendation_provider.dart';
import 'package:what_to_wear_flutter/features/recommendation/repository/recommendation_repository.dart';
import 'package:what_to_wear_flutter/features/wardrobe/provider/wardrobe_provider.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'services/ai/ai_service_provider.dart';
import 'services/ai/gemini/gemini_image_analyzer.dart';
import 'services/ai/gemini/gemini_image_generator.dart';
import 'services/ai/gemini/gemini_outfit_recommender.dart';
import 'services/ai/zhipu/zhipu_image_analyzer.dart';
import 'services/ai/zhipu/zhipu_image_generator.dart';
import 'services/ai/zhipu/zhipu_outfit_recommender.dart';
import 'services/ai/qianwen/qianwen_image_analyzer.dart';
import 'services/ai/qianwen/qianwen_image_generator.dart';
import 'services/ai/qianwen/qianwen_outfit_recommender.dart';
import 'services/ai/doubao/doubao_image_analyzer.dart';
import 'services/ai/doubao/doubao_image_generator.dart';
import 'services/ai/doubao/doubao_outfit_recommender.dart';
import 'services/storage_service.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';
import 'utils/privacy_utils.dart';
import 'services/analytics_service.dart';

import 'package:go_router/go_router.dart';
import 'package:what_to_wear_flutter/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale data for date formatting
  await initializeDateFormatting('zh_CN', null);

  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize UMeng if privacy policy agreed
  final prefs = await SharedPreferences.getInstance();
  final agreedPrivacy = prefs.getBool('agreed_privacy') ?? false;
  if (agreedPrivacy) {
    const umengAppKey = String.fromEnvironment(
      'UMENG_APP_KEY',
      defaultValue: '699b155d6f259537c7605e61',
    );
    UmengCommonSdk.initCommon(umengAppKey, umengAppKey, 'Umeng');
    AnalyticsService.init();
  }

  // Create AI service provider based on AI_PROVIDER env var
  // Usage: --dart-define=AI_PROVIDER=zhipu (default: gemini)
  const aiProvider = String.fromEnvironment(
    'AI_PROVIDER',
    defaultValue: 'gemini',
  );
  final aiServiceProvider = switch (aiProvider) {
    'zhipu' => AIServiceProvider(
      imageAnalyzer: ZhipuImageAnalyzer(),
      imageGenerator: ZhipuImageGenerator(),
      outfitRecommender: ZhipuOutfitRecommender(),
    ),
    'qianwen' => AIServiceProvider(
      imageAnalyzer: QianwenImageAnalyzer(),
      imageGenerator: QianwenImageGenerator(),
      outfitRecommender: QianwenOutfitRecommender(),
    ),
    'doubao' => AIServiceProvider(
      imageAnalyzer: DoubaoImageAnalyzer(),
      imageGenerator: DoubaoImageGenerator(),
      outfitRecommender: DoubaoOutfitRecommender(),
    ),
    _ => AIServiceProvider(
      imageAnalyzer: GeminiImageAnalyzer(),
      imageGenerator: GeminiImageGenerator(),
      outfitRecommender: GeminiOutfitRecommender(),
    ),
  };

  runApp(
    WhatToWearApp(
      storageService: storageService,
      aiServiceProvider: aiServiceProvider,
    ),
  );
}

class WhatToWearApp extends StatelessWidget {
  final StorageService storageService;
  final AIServiceProvider aiServiceProvider;

  const WhatToWearApp({
    super.key,
    required this.storageService,
    required this.aiServiceProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<AIServiceProvider>.value(value: aiServiceProvider),
        Provider<ProfileRepository>(
          create: (_) => ProfileRepository(storageService),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileProvider(context.read<ProfileRepository>())..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => WardrobeProvider(storageService)..loadWardrobe(),
        ),
        Provider<RecommendationRepository>(
          create: (_) => RecommendationRepository(storageService),
        ),
        ChangeNotifierProvider(
          create: (context) => RecommendationProvider(
            context.read<RecommendationRepository>(),
            aiServiceProvider,
          ),
        ),
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final router = AppRouter.createRouter(
            hasCompletedOnboarding: profileProvider.hasCompletedOnboarding(),
          );

          return MaterialApp.router(
            routerConfig: router,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appName ?? '今天穿什么',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: profileProvider.themeMode,
            locale: profileProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('zh'), Locale('en')],
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final hasAgreed = await checkAndShowPrivacyDialog(context);
      if (!hasAgreed) {
        SystemNavigator.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.bgAlt,
          border: Border(
            top: BorderSide(color: context.borderColor, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.style_outlined,
                  activeIcon: Icons.style,
                  label:
                      AppLocalizations.of(context)?.tabRecommendation ?? '推荐',
                  isActive: _currentIndex == 0,
                  onTap: () {
                    setState(() => _currentIndex = 0);
                    context.go(AppRoutes.home);
                  },
                ),
                _NavItem(
                  icon: Icons.checkroom_outlined,
                  activeIcon: Icons.checkroom,
                  label: AppLocalizations.of(context)?.tabWardrobe ?? '衣橱',
                  isActive: _currentIndex == 1,
                  onTap: () {
                    setState(() => _currentIndex = 1);
                    context.go(AppRoutes.wardrobe);
                  },
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppLocalizations.of(context)?.tabProfile ?? '我的',
                  isActive: _currentIndex == 2,
                  onTap: () {
                    setState(() => _currentIndex = 2);
                    context.go(AppRoutes.profile);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primaryBlue : context.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.primaryBlue : context.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
