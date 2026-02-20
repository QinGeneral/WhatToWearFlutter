import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../providers/wardrobe_provider.dart';
import '../services/ai/ai_outfit_recommender.dart';
import '../theme/app_theme.dart';

class CustomOutfitPage extends StatefulWidget {
  const CustomOutfitPage({super.key});

  @override
  State<CustomOutfitPage> createState() => _CustomOutfitPageState();
}

class _CustomOutfitPageState extends State<CustomOutfitPage> {
  final _textController = TextEditingController();
  String _activeCategory = '日期';
  final _selections = <String, String>{};
  final _customTags = <String, List<String>>{};

  static const _quickTags = [
    {
      'category': '日期',
      'options': ['今天', '明天', '后天', '周末', '下周', '工作日'],
    },
    {
      'category': '地点',
      'options': ['室内', '户外', '商场', '咖啡厅', '办公室', '公园'],
    },
    {
      'category': '活动',
      'options': ['生日聚会', '开会', '约会', '运动', '休闲', '正式晚宴'],
    },
    {
      'category': '人物',
      'options': ['朋友', '同事', '家人', '伴侣', '客户'],
    },
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleTagClick(String tag) {
    setState(() {
      _selections[_activeCategory] = tag;
    });

    // Update text content
    final lines = _textController.text.split('\n');
    final pattern = RegExp('^$_activeCategory:');
    final newLine = '$_activeCategory: $tag';

    bool found = false;
    final newLines = lines.map((line) {
      if (pattern.hasMatch(line)) {
        found = true;
        return newLine;
      }
      return line;
    }).toList();

    if (!found) {
      final cleanPrev = _textController.text.trim();
      _textController.text = cleanPrev.isEmpty
          ? newLine
          : '$cleanPrev\n$newLine';
    } else {
      _textController.text = newLines.join('\n');
    }
  }

  void _showAddCustomTagDialog() {
    final tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            '添加"$_activeCategory"选项',
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: tagController,
            autofocus: true,
            style: TextStyle(color: context.textPrimary),
            decoration: InputDecoration(
              hintText: '请输入自定义内容',
              hintStyle: TextStyle(color: context.textTertiary),
              filled: true,
              fillColor: context.bgPrimary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('取消', style: TextStyle(color: context.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final tag = tagController.text.trim();
                if (tag.isNotEmpty) {
                  setState(() {
                    _customTags.putIfAbsent(_activeCategory, () => []);
                    if (!_customTags[_activeCategory]!.contains(tag)) {
                      _customTags[_activeCategory]!.add(tag);
                    }
                  });
                  _handleTagClick(tag);
                  Navigator.of(ctx).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('确认', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _removeCustomTag(String tag) {
    setState(() {
      _customTags[_activeCategory]?.remove(tag);
      if (_selections[_activeCategory] == tag) {
        _selections.remove(_activeCategory);
      }
    });
  }

  Future<void> _handleSubmit() async {
    final rp = context.read<RecommendationProvider>();
    final wp = context.read<WardrobeProvider>();

    final text = _textController.text.trim();

    // Parse selections from tags or text
    String parseField(String category) {
      return _selections[category] ??
          RegExp('$category:\\s*(.*)').firstMatch(text)?.group(1) ??
          '';
    }

    final request = UserRequest(
      date: parseField('日期'),
      location: parseField('地点'),
      activity: parseField('活动'),
      person: parseField('人物'),
      requirements: text,
    );

    await rp.generateAIRecommendation(request, wp.items);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final defaultOptions =
        (_quickTags.firstWhere(
                  (t) => t['category'] == _activeCategory,
                  orElse: () => {'category': '', 'options': <String>[]},
                )['options']
                as List?)
            ?.cast<String>() ??
        [];
    final userOptions = _customTags[_activeCategory] ?? [];
    final allOptions = [...defaultOptions, ...userOptions];

    return Consumer<RecommendationProvider>(
      builder: (context, rp, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: context.bgPrimary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.close, color: context.textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  '定制穿搭',
                  style: TextStyle(
                    color: context.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.history, color: context.textPrimary),
                    onPressed: () {
                      // TODO: navigate to history
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            '您的搭配需求？',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '按指引填写日期、地点、活动和人物，获取精准方案',
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Text input area
                          Container(
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: context.borderColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _textController,
                                  maxLines: 8,
                                  style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        '日期: [例如：本周末，下午]\n地点: [例如：户外，城市公园]\n活动: [例如：朋友的休闲生日聚会]\n人物: [例如：亲近的朋友]',
                                    hintStyle: TextStyle(
                                      color: context.textTertiary.withValues(
                                        alpha: 0.4,
                                      ),
                                      height: 1.6,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.bgPrimary.withValues(
                                          alpha: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${_textController.text.length}/200',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Category tabs
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _quickTags.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final cat =
                                    _quickTags[index]['category'] as String;
                                final isActive = cat == _activeCategory;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _activeCategory = cat),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppTheme.primaryBlue
                                          : context.cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isActive
                                            ? AppTheme.primaryBlue
                                            : context.borderColor.withValues(
                                                alpha: 0.3,
                                              ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isActive
                                              ? Colors.white
                                              : context.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Options panel
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: context.borderColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                ...allOptions.map((option) {
                                  final isSelected =
                                      _selections[_activeCategory] == option;
                                  final isCustom = userOptions.contains(option);
                                  return GestureDetector(
                                    onTap: () => _handleTagClick(option),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppTheme.primaryBlue.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.primaryBlue
                                              : context.borderColor.withValues(
                                                  alpha: 0.3,
                                                ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isSelected
                                                  ? AppTheme.primaryBlue
                                                  : context.textSecondary,
                                            ),
                                          ),
                                          if (isCustom) ...[
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () =>
                                                  _removeCustomTag(option),
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: context.textTertiary
                                                      .withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 10,
                                                  color: context.textTertiary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                // Add custom tag button
                                GestureDetector(
                                  onTap: _showAddCustomTagDialog,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: context.borderColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 16,
                                          color: context.textTertiary
                                              .withValues(alpha: 0.7),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '自定义',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: context.textTertiary
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom button
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.bgPrimary.withValues(alpha: 0.0),
                          context.bgPrimary,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: rp.isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 4,
                            shadowColor: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: rp.isLoading
                                    ? Colors.black38
                                    : Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                rp.isLoading ? '生成中...' : '获取搭配方案',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: rp.isLoading
                                      ? Colors.black38
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (rp.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryBlue,
                          strokeWidth: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '正在为您定制专属穿搭...',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
