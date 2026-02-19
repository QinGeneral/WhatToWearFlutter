import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/recommendation_provider.dart';
import '../theme/app_theme.dart';
import 'custom_outfit_page.dart';
import 'outfit_detail_page.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  @override
  void initState() {
    super.initState();
    final recProvider = context.read<RecommendationProvider>();
    recProvider.fetchWeather();
    recProvider.loadFavorites();
    recProvider.loadCurrentRecommendation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, recProvider, _) {
        return Scaffold(
          backgroundColor: context.bgPrimary,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CustomOutfitPage()),
              );
            },
            backgroundColor: AppTheme.primaryBlue,
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
    final dateStr =
        '${now.month}月${now.day}日 ${DateFormat.EEEE('zh_CN').format(now)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [context.textPrimary, context.textSecondary],
            ).createShader(bounds),
            child: Text(
              '为你推荐',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
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
            '点击右下角按钮获取穿搭推荐',
            style: TextStyle(color: context.textSecondary, fontSize: 14),
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
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (weather.icon != null && weather.icon!.endsWith('.svg'))
                      SvgPicture.asset(weather.icon!, width: 32, height: 32)
                    else
                      Text(
                        weather.icon ?? '☀️',
                        style: const TextStyle(fontSize: 28),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      weather.condition,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary,
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
                Row(
                  children: [
                    Text(
                      '紫外线${weather.uvIndex ?? "中"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '湿度 ${weather.humidity}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '舒适度：${weather.comfortLevel ?? "一般"}',
                      style: TextStyle(
                        fontSize: 12,
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
                colors: [Color(0xFF87CEEB), Color(0xFF4A90D9)],
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                OutfitDetailPage(recommendationId: recommendation.id),
          ),
        );
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
                          '${recommendation.matchPercentage ?? 85}% 匹配',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '商务休闲 • 透气棉质',
                          style: TextStyle(
                            fontSize: 11,
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
                          ? AppTheme.errorRed
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
                  style: TextStyle(
                    fontSize: 13,
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
      return Image.memory(base64Decode(base64Str), fit: BoxFit.cover);
    } else if (src != null && src.isNotEmpty) {
      try {
        return Image.memory(base64Decode(src), fit: BoxFit.cover);
      } catch (_) {}
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
                '备选方案',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
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
    final title = alt.items.top?.name ?? '时尚单品';
    final image = alt.mainImage;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OutfitDetailPage(recommendationId: alt.id),
          ),
        );
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '经典商务',
                    style: TextStyle(fontSize: 10, color: context.textTertiary),
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
        return Image.memory(base64Decode(decoded), fit: BoxFit.cover);
      } catch (_) {}
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
