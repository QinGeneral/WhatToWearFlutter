import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/features/recommendation/provider/recommendation_provider.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecommendationProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, rp, _) {
        final l10n = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context).languageCode;
        return Scaffold(
          backgroundColor: context.bgPrimary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.textPrimary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              l10n.outfitHistory,
              style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: rp.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: context.textTertiary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noHistoryYet,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rp.history.length,
                  itemBuilder: (context, index) {
                    final rec = rp.history[index];
                    final date = DateTime.tryParse(rec.date);
                    final dateStr = date != null
                        ? locale == 'zh'
                            ? DateFormat('MM月dd日 HH:mm').format(date)
                            : DateFormat('MMM d, HH:mm').format(date)
                        : rec.date;

                    return Dismissible(
                      key: ValueKey(rec.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.confirmDelete),
                            content: Text(l10n.confirmDeleteHistory),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  l10n.delete,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) => rp.deleteHistory(rec.id),
                      child: GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.outfitDetail, extra: rec);
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
                                  width: 72,
                                  height: 72,
                                  child: _buildImage(context, rec.mainImage),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec.title,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                            color: context.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateStr,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: context.textTertiary,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '${rec.matchPercentage ?? 85}${l10n.matchSuffix}',
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                color: AppColors.primaryBlue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        if (rec.isFavorite) ...[
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.favorite,
                                            size: 14,
                                            color: AppColors.errorRed,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: context.textTertiary,
                                size: 20,
                              ),
                            ],
                          ),
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
      child: Icon(
        Icons.checkroom,
        size: 28,
        color: context.textTertiary.withValues(alpha: 0.5),
      ),
    );
  }
}
