import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/features/profile/provider/profile_provider.dart';
import 'package:what_to_wear_flutter/features/recommendation/provider/recommendation_provider.dart';
import 'package:what_to_wear_flutter/features/wardrobe/provider/wardrobe_provider.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:what_to_wear_flutter/l10n/weather_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, RecommendationProvider, WardrobeProvider>(
      builder: (context, pp, rp, wp, _) {
        final profile = pp.profile;
        final identityConfig = profile?.identity;

        return Scaffold(
          backgroundColor: context.bgAlt,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // Avatar
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (profile?.nickname?.isNotEmpty == true)
                            ? profile!.nickname![0].toUpperCase()
                            : '?',
                        style: context.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    profile?.nickname ??
                        AppLocalizations.of(context)?.guest ??
                        'Guest',
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Identity tag
                  if (identityConfig != null)
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.onboarding);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: identityConfig.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              identityConfig.icon,
                              size: 16,
                              color: identityConfig.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              identityConfig.displayName,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: identityConfig.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Weather info
                  if (rp.weather != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '📍 ${rp.weather!.location ?? AppLocalizations.of(context)?.unknown ?? "未知"} · ${rp.weather!.temperature}°C ${AppLocalizations.of(context)?.translateWeatherCondition(rp.weather!.condition) ?? rp.weather!.condition}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.textTertiary,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Stats grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _StatCard(
                          value: '${rp.favorites.length}',
                          label:
                              AppLocalizations.of(context)?.favoriteOutfits ??
                              '收藏穿搭',
                          color: AppColors.errorRed,
                        ),
                        const SizedBox(width: 16),
                        _StatCard(
                          value: '${rp.history.length}',
                          label:
                              AppLocalizations.of(context)?.outfitHistory ??
                              '穿搭历史',
                          color: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Function buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _FunctionButton(
                          icon: Icons.favorite_border,
                          label:
                              AppLocalizations.of(context)?.favoriteOutfits ??
                              '收藏穿搭',
                          color: AppColors.errorRed,
                          onTap: () => context.push(AppRoutes.favorites),
                        ),
                        const SizedBox(height: 12),
                        _FunctionButton(
                          icon: Icons.history,
                          label:
                              AppLocalizations.of(context)?.outfitHistory ??
                              '穿搭历史',
                          color: AppColors.primaryBlue,
                          onTap: () => context.push(AppRoutes.history),
                        ),
                        const SizedBox(height: 12),
                        _FunctionButton(
                          icon: context.isDark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          label: context.isDark
                              ? (AppLocalizations.of(
                                      context,
                                    )?.switchLightMode ??
                                    '切换浅色主题')
                              : (AppLocalizations.of(context)?.switchDarkMode ??
                                    '切换深色主题'),
                          color: AppColors.warningYellow,
                          onTap: () => pp.toggleTheme(),
                        ),
                        const SizedBox(height: 12),
                        _FunctionButton(
                          icon: Icons.language,
                          label:
                              AppLocalizations.of(context)?.switchLanguage ??
                              '切换语言',
                          color: AppColors.successGreen,
                          onTap: () {
                            final newLang = pp.locale.languageCode == 'zh'
                                ? 'en'
                                : 'zh';
                            pp.setLanguage(newLang);
                          },
                        ),
                        const SizedBox(height: 12),
                        _FunctionButton(
                          icon: Icons.help_outline,
                          label:
                              AppLocalizations.of(context)?.helpAndFeedback ??
                              '帮助与反馈',
                          color: AppColors.accentPurple,
                          onTap: () => context.push(AppRoutes.profileHelp),
                        ),
                        if (kDebugMode) ...[
                          const SizedBox(height: 12),
                          _FunctionButton(
                            icon: Icons.developer_mode,
                            label:
                                AppLocalizations.of(
                                  context,
                                )?.developerOptions ??
                                '开发者选项',
                            color: Colors.teal,
                            onTap: () =>
                                context.push(AppRoutes.profileDeveloper),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Privacy Policy Link
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.profilePrivacy);
                        },
                        child: Text(
                          AppLocalizations.of(context)?.privacyPolicy ?? '隐私协议',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.textTertiary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.textTheme.displayMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.textTertiary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FunctionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FunctionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: context.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
