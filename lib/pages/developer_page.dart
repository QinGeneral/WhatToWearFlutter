import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/recommendation_provider.dart';
import '../providers/wardrobe_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'weather_test_page.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '[${TimeOfDay.now().format(context)}] $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProfileProvider>();
    final rp = context.watch<RecommendationProvider>();
    final wp = context.watch<WardrobeProvider>();

    return Scaffold(
      backgroundColor: context.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '开发者选项',
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'DEBUG',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorRed,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info
            _SectionTitle(title: '应用信息'),
            const SizedBox(height: 8),
            _InfoCard(
              items: [
                _InfoRow(label: '应用名', value: 'Cloova'),
                _InfoRow(label: '版本', value: '1.0.0+1'),
                _InfoRow(
                  label: '主题',
                  value: pp.themeMode == ThemeMode.dark ? '深色' : '浅色',
                ),
                _InfoRow(
                  label: 'Onboarding',
                  value: pp.hasCompletedOnboarding() ? '已完成' : '未完成',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Data Stats
            _SectionTitle(title: '数据统计'),
            const SizedBox(height: 8),
            _InfoCard(
              items: [
                _InfoRow(label: '衣橱物品', value: '${wp.items.length} 件'),
                _InfoRow(label: '推荐记录', value: '${rp.history.length} 条'),
                _InfoRow(label: '收藏穿搭', value: '${rp.favorites.length} 个'),
                _InfoRow(
                  label: '当前推荐',
                  value: rp.currentRecommendation != null ? '有' : '无',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weather Info
            _SectionTitle(title: '天气数据'),
            const SizedBox(height: 8),
            if (rp.weather != null)
              _InfoCard(
                items: [
                  _InfoRow(label: '位置', value: rp.weather!.location ?? '未知'),
                  _InfoRow(label: '温度', value: '${rp.weather!.temperature}°C'),
                  _InfoRow(label: '天气', value: rp.weather!.condition),
                  _InfoRow(label: '湿度', value: '${rp.weather!.humidity}%'),
                  _InfoRow(
                    label: '舒适度',
                    value: rp.weather!.comfortLevel ?? '未知',
                  ),
                  _InfoRow(label: '图标路径', value: rp.weather!.icon ?? 'null'),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Center(
                  child: Text(
                    '暂无天气数据',
                    style: TextStyle(color: context.textTertiary),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Profile Info
            _SectionTitle(title: '用户资料'),
            const SizedBox(height: 8),
            _InfoCard(
              items: [
                _InfoRow(label: '昵称', value: pp.profile?.nickname ?? '未设置'),
                _InfoRow(
                  label: '身份',
                  value: pp.profile?.identity?.name ?? '未设置',
                ),
                _InfoRow(label: '创建时间', value: pp.profile?.createdAt ?? '未设置'),
              ],
            ),

            const SizedBox(height: 24),

            // Component Testing
            _SectionTitle(title: '组件测试'),
            const SizedBox(height: 8),
            _ActionButton(
              icon: Icons.cloud,
              label: '天气组件测试',
              color: const Color(0xFF4A90D9),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WeatherTestPage()),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            _SectionTitle(title: '调试操作'),
            const SizedBox(height: 8),
            _ActionButton(
              icon: Icons.refresh,
              label: '重新获取天气',
              color: AppTheme.primaryBlue,
              onTap: () async {
                _addLog('开始获取天气...');
                try {
                  await rp.fetchWeather();
                  _addLog('天气获取成功: ${rp.weather?.condition ?? "未知"}');
                } catch (e) {
                  _addLog('天气获取失败: $e');
                }
              },
            ),
            const SizedBox(height: 8),
            _ActionButton(
              icon: Icons.delete_sweep,
              label: '清空推荐历史',
              color: AppTheme.warningYellow,
              onTap: () async {
                final confirmed = await _showConfirmDialog(
                  context,
                  '确定清空所有推荐历史？',
                );
                if (confirmed == true) {
                  await rp.clearHistory();
                  _addLog('推荐历史已清空');
                }
              },
            ),
            const SizedBox(height: 8),
            _ActionButton(
              icon: Icons.delete_forever,
              label: '清空所有数据',
              color: AppTheme.errorRed,
              onTap: () async {
                final confirmed = await _showConfirmDialog(
                  context,
                  '⚠️ 确定清空所有数据？此操作不可恢复！',
                );
                if (confirmed == true) {
                  final storage = StorageService();
                  await storage.init();
                  await storage.clearAll();
                  _addLog('所有数据已清空，请重启应用');
                }
              },
            ),
            const SizedBox(height: 8),
            _ActionButton(
              icon: Icons.person_off,
              label: '重置 Onboarding',
              color: AppTheme.accentPurple,
              onTap: () async {
                final confirmed = await _showConfirmDialog(
                  context,
                  '确定重置 Onboarding 状态？下次打开应用将重新引导。',
                );
                if (confirmed == true) {
                  await pp.resetOnboarding();
                  _addLog('Onboarding 已重置');
                }
              },
            ),

            // Log output
            if (_logs.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionTitle(title: '操作日志'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _logs
                      .take(20)
                      .map(
                        (log) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('确认', style: TextStyle(color: context.textPrimary)),
        content: Text(message, style: TextStyle(color: context.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('取消', style: TextStyle(color: context.textTertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('确定', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

// Reusable widgets

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final row = entry.value;
          final isLast = entry.key == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      row.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        row.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) Divider(color: context.borderColor, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: context.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
