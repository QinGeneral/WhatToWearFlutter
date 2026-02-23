import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/features/recommendation/provider/recommendation_provider.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:what_to_wear_flutter/features/recommendation/view/outfit_detail_page.dart';

class FavoriteOutfitsPage extends StatelessWidget {
  const FavoriteOutfitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, rp, _) {
        return Scaffold(
          backgroundColor: context.bgPrimary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              '收藏穿搭',
              style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: rp.favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: context.textTertiary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '还没有收藏的穿搭',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '在推荐中点击❤️收藏喜欢的穿搭',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: rp.favorites.length,
                  itemBuilder: (context, index) {
                    final rec = rp.favorites[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(
                              name: '/OutfitDetailPage',
                            ),
                            builder: (_) =>
                                OutfitDetailPage(recommendationId: rec.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.borderColor),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildImage(context, rec.mainImage),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => rp.toggleFavorite(rec),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.4,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: AppColors.errorRed,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rec.title,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${rec.matchPercentage ?? 85}% 匹配',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildImage(BuildContext context, String? src) {
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
      color: context.surfaceColor,
      child: Center(
        child: Icon(
          Icons.style,
          size: 40,
          color: context.textTertiary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
