import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../theme/app_theme.dart';
import 'outfit_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecommendationProvider>().loadHistory();
  }

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
              '穿搭历史',
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
                        '暂无历史记录',
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 14,
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
                        ? DateFormat('MM月dd日 HH:mm').format(date)
                        : rec.date;

                    return Dismissible(
                      key: ValueKey(rec.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('确认删除'),
                            content: const Text('确定删除此条历史记录？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  '删除',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) => rp.deleteHistory(rec.id),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OutfitDetailPage(recommendationId: rec.id),
                            ),
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
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: context.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateStr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '${rec.matchPercentage ?? 85}% 匹配',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryBlue,
                                          ),
                                        ),
                                        if (rec.isFavorite) ...[
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.favorite,
                                            size: 14,
                                            color: AppTheme.errorRed,
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
}
