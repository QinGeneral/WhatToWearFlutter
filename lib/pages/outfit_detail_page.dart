import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/models.dart';
import '../providers/recommendation_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/share_dialog.dart';
import 'add_item_page.dart';

class OutfitDetailPage extends StatelessWidget {
  final String recommendationId;

  const OutfitDetailPage({super.key, required this.recommendationId});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, rp, _) {
        final rec = rp.getRecommendationById(recommendationId);
        if (rec == null) {
          return Scaffold(
            backgroundColor: context.bgPrimary,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: context.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(
              child: Text(
                '推荐未找到',
                style: TextStyle(color: context.textSecondary),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: context.bgPrimary,
          body: Stack(
            children: [
              Container(
                color: context.bgPrimary, // Ensure background is captured
                child: CustomScrollView(
                  slivers: [
                    // App bar with image
                    SliverAppBar(
                      expandedHeight: 400,
                      pinned: true,
                      backgroundColor: context.bgPrimary,
                      leading: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      actions: const [],
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildHeroImage(context, rec),
                      ),
                    ),

                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Title & match
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  rec.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryBlue,
                                      AppTheme.accentPurple,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${rec.matchPercentage ?? 85}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _buildTags(rec),
                          ),
                          const SizedBox(height: 20),

                          // Reasoning
                          if (rec.reasoning != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.cardColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: context.borderColor),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '💡',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      rec.reasoning!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.6,
                                        color: context.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Outfit items
                          Text(
                            '穿搭单品',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._buildOutfitItems(context, rec),

                          const SizedBox(height: 24),

                          // Weather context
                          _buildWeatherContext(context, rec),
                          const SizedBox(
                            height: 100,
                          ), // Extra space for bottom bar
                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action Bar
              Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: Row(
                  children: [
                    // Favorite Button (Duplicate of top, but good for easy access)
                    GestureDetector(
                      onTap: () => rp.toggleFavorite(rec),
                      child: Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: context.cardColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              rec.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: rec.isFavorite
                                  ? AppTheme.errorRed
                                  : context.textSecondary,
                              size: 24,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '收藏',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.textTertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Share Button
                    ShareButton(recommendation: rec),

                    const SizedBox(width: 12),

                    // Generate Button
                    GenerateButton(recommendation: rec),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroImage(BuildContext context, Recommendation rec) {
    // Priority: Generated Image > Main Image
    final src = rec.generatedImage ?? rec.mainImage;

    if (src != null && src.isNotEmpty) {
      try {
        final decoded = src.startsWith('data:') ? src.split(',').last : src;
        // Check if it's a network URL (though our app mostly uses base64 for now)
        if (src.startsWith('http')) {
          return Image.network(src, fit: BoxFit.cover);
        }
        return Image.memory(base64Decode(decoded), fit: BoxFit.cover);
      } catch (_) {}
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.3),
            AppTheme.accentPurple.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.style,
          size: 80,
          color: context.textTertiary.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  List<Widget> _buildTags(Recommendation rec) {
    final tags = <String>[];
    if (rec.occasion != null) tags.add(rec.occasion!.label);
    if (rec.weather.temperature > 25) tags.add('夏季');
    if (rec.weather.temperature < 15) tags.add('保暖');
    tags.add(rec.weather.condition);
    if (rec.context?.tags != null) tags.addAll(rec.context!.tags!);

    return tags.take(5).map((tag) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildOutfitItems(BuildContext context, Recommendation rec) {
    final entries = <MapEntry<String, WardrobeItem?>>[];
    entries.add(MapEntry('上装', rec.items.top));
    entries.add(MapEntry('下装', rec.items.bottom));
    entries.add(MapEntry('鞋履', rec.items.shoes));
    if (rec.items.outerwear != null) {
      entries.add(MapEntry('外套', rec.items.outerwear));
    }
    if (rec.items.accessories != null) {
      for (final acc in rec.items.accessories!) {
        entries.add(MapEntry('配饰', acc));
      }
    }

    return entries.where((e) => e.value != null).map((entry) {
      final item = entry.value!;
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddItemPage(itemId: item.id)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: _buildItemImage(context, item),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.key} · ${item.category.label}',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textTertiary,
                      ),
                    ),
                    if (item.brand != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.brand!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textTertiary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.textTertiary, size: 20),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildItemImage(BuildContext context, WardrobeItem item) {
    final src =
        item.optimizedImage ??
        (item.images.isNotEmpty ? item.images.first : null);
    if (src != null && src.isNotEmpty) {
      try {
        final decoded = src.startsWith('data:') ? src.split(',').last : src;
        return Image.memory(base64Decode(decoded), fit: BoxFit.cover);
      } catch (_) {}
    }
    return Container(
      color: context.surfaceColor,
      child: Icon(
        Icons.checkroom,
        size: 28,
        color: context.textTertiary.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildWeatherContext(BuildContext context, Recommendation rec) {
    return Container(
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
            '天气',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (rec.weather.icon != null &&
                  rec.weather.icon!.endsWith('.svg'))
                SvgPicture.asset(rec.weather.icon!, width: 36, height: 36)
              else
                Text(
                  rec.weather.icon ?? '☀️',
                  style: const TextStyle(fontSize: 32),
                ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rec.weather.temperature}°C · ${rec.weather.condition}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    '湿度 ${rec.weather.humidity}%',
                    style: TextStyle(fontSize: 13, color: context.textTertiary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final Recommendation recommendation;

  const ShareButton({super.key, required this.recommendation});

  void _handleShare(BuildContext context) {
    showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.transparent, // Handled by dialog backdrop
      builder: (context) => ShareDialog(recommendation: recommendation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleShare(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: context.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ios_share, color: context.textSecondary, size: 24),
            const SizedBox(height: 2),
            Text(
              '分享',
              style: TextStyle(
                fontSize: 10,
                color: context.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenerateButton extends StatefulWidget {
  final Recommendation recommendation;

  const GenerateButton({super.key, required this.recommendation});

  @override
  State<GenerateButton> createState() => _GenerateButtonState();
}

class _GenerateButtonState extends State<GenerateButton> {
  bool _isGenerating = false;

  Future<void> _handleGenerate() async {
    if (_isGenerating) return;
    setState(() => _isGenerating = true);

    try {
      await context.read<RecommendationProvider>().generateTryOnImage(
        widget.recommendation,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('生成失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGenerated = widget.recommendation.generatedImage != null;
    if (hasGenerated) return const SizedBox.shrink();

    return Expanded(
      child: GestureDetector(
        onTap: _handleGenerate,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isGenerating)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.textPrimary,
                  ),
                )
              else
                Icon(Icons.auto_awesome, color: context.textPrimary),
              const SizedBox(width: 8),
              Text(
                _isGenerating ? '生成中...' : '生成试穿图',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
