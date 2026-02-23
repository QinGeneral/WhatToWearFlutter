import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/features/recommendation/provider/recommendation_provider.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'package:what_to_wear_flutter/l10n/weather_localizations.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final recProvider = context.read<RecommendationProvider>();
      recProvider.fetchWeather();
      recProvider.loadFavorites();
      recProvider.loadCurrentRecommendation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, recProvider, _) {
        return Scaffold(
          backgroundColor: context.bgPrimary,
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              context.push(AppRoutes.customOutfit);
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 16),

                  // Weather card
                  if (recProvider.weather != null)
                    _WeatherCard(weather: recProvider.weather!),

                  const SizedBox(height: 20),

                  // Top pick
                  if (recProvider.currentRecommendation != null)
                    _TopPickCard(
                      recommendation: recProvider.currentRecommendation!,
                      onToggleFavorite: () => recProvider.toggleFavorite(
                        recProvider.currentRecommendation!,
                      ),
                    )
                  else
                    _buildEmptyState(context, recProvider),

                  const SizedBox(height: 24),

                  // Alternatives
                  if (recProvider.alternativeRecommendations.isNotEmpty)
                    _AlternativePlans(
                      alternatives: recProvider.alternativeRecommendations,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = locale == 'zh'
        ? '${now.month}月${now.day}日 ${DateFormat.EEEE('zh_CN').format(now)}'
        : DateFormat.yMMMMEEEEd('en_US').format(now);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [context.textPrimary, context.textSecondary],
            ).createShader(bounds),
            child: Text(
              AppLocalizations.of(context)?.forYouRecommendation ?? '为你推荐',
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    RecommendationProvider recProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.style_outlined, size: 64, color: context.textTertiary),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)?.clickFabToGetRecommendation ??
                '点击右下角按钮获取穿搭推荐',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════ Weather Card ═══════
class _WeatherCard extends StatelessWidget {
  final WeatherInfo weather;

  const _WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: context.textTheme.displayLarge?.copyWith(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (weather.icon != null && weather.icon!.endsWith('.svg'))
                      SvgPicture.asset(weather.icon!, width: 32, height: 32)
                    else
                      Text(
                        weather.icon ?? '☀️',
                        style: context.textTheme.displayMedium,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.translateWeatherCondition(weather.condition) ??
                          weather.condition,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (weather.location != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '📍 ${weather.location}',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)?.uvIndexPrefix ?? "紫外线"}${weather.uvIndex ?? (AppLocalizations.of(context)?.uvMedium ?? "中")}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.textTertiary,
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)?.humidityPrefix ?? "湿度 "}${weather.humidity}%',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.textTertiary,
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)?.comfortLevelPrefix ?? "舒适度："}${AppLocalizations.of(context)?.translateComfortLevel(weather.comfortLevel ?? "一般") ?? (AppLocalizations.of(context)?.comfortNormal ?? "一般")}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.weatherSunnyStart,
                  AppColors.weatherSunnyEnd,
                ],
              ),
            ),
            child: Center(
              child: weather.icon != null && weather.icon!.endsWith('.svg')
                  ? SvgPicture.asset(weather.icon!, width: 48, height: 48)
                  : Text(
                      weather.icon ?? '☀️',
                      style: const TextStyle(fontSize: 40),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════ Top Pick Card ═══════
class _TopPickCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onToggleFavorite;

  const _TopPickCard({
    required this.recommendation,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.outfitDetail, extra: recommendation);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main image
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(context),
                    // Match badge
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${recommendation.matchPercentage ?? 85}${AppLocalizations.of(context)?.matchSuffix ?? "% 匹配"}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title + Favorite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(
                                context,
                              )?.businessCasualBreathable ??
                              '商务休闲 • 透气棉质',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleFavorite,
                    child: Icon(
                      Icons.favorite,
                      color: recommendation.isFavorite
                          ? AppColors.errorRed
                          : context.textTertiary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            if (recommendation.reasoning != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  recommendation.reasoning!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final src = recommendation.mainImage;
    if (src != null && src.startsWith('data:')) {
      final base64Str = src.split(',').last;
      return Image.memory(
        base64Decode(base64Str),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else if (src != null && src.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(src),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (e) {
        debugPrint('Caught error: $e');
      }
    }
    return Container(
      color: context.surfaceColor,
      child: Center(
        child: Icon(
          Icons.style,
          size: 64,
          color: context.textTertiary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// ═══════ Alternative Plans ═══════
class _AlternativePlans extends StatelessWidget {
  final List<Recommendation> alternatives;

  const _AlternativePlans({required this.alternatives});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.alternativePlan ?? '备选方案',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: alternatives.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final alt = alternatives[index];
              return _AlternativeCard(alt: alt);
            },
          ),
        ),
      ],
    );
  }
}

class _AlternativeCard extends StatelessWidget {
  final Recommendation alt;

  const _AlternativeCard({required this.alt});

  @override
  Widget build(BuildContext context) {
    final title =
        alt.items.top?.name ??
        (AppLocalizations.of(context)?.fashionItem ?? '时尚单品');
    final image = alt.mainImage;

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.outfitDetail, extra: alt);
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: _buildAltImage(context, image),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)?.classicBusiness ?? '经典商务',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAltImage(BuildContext context, String? src) {
    if (src != null && src.isNotEmpty) {
      try {
        final decoded = src.startsWith('data:') ? src.split(',').last : src;
        return Image.memory(
          base64Decode(decoded),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (e) {
        debugPrint('Caught error: $e');
      }
    }
    return Container(
      color: context.cardColor,
      child: Center(
        child: Icon(
          Icons.checkroom,
          size: 36,
          color: context.textTertiary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
