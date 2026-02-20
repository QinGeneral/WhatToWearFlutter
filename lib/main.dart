import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/wardrobe_provider.dart';
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
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'pages/onboarding_page.dart';
import 'pages/recommendation_page.dart';
import 'pages/wardrobe_page.dart';
import 'pages/profile_page.dart';

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
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(storageService)..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => WardrobeProvider(storageService)..loadWardrobe(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RecommendationProvider(storageService, aiServiceProvider),
        ),
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return MaterialApp(
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
            home: profileProvider.isLoading
                ? const _SplashScreen()
                : profileProvider.hasCompletedOnboarding()
                ? const _MainShell()
                : const OnboardingPage(),
          );
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.accentPurple],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.checkroom, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)?.appName ?? '今天穿什么',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  final _pages = const [RecommendationPage(), WardrobePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.checkroom_outlined,
                  activeIcon: Icons.checkroom,
                  label: AppLocalizations.of(context)?.tabWardrobe ?? '衣橱',
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppLocalizations.of(context)?.tabProfile ?? '我的',
                  isActive: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
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
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryBlue : context.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppTheme.primaryBlue : context.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
