import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/wardrobe_provider.dart';
import '../services/ai/ai_service_provider.dart';
import '../theme/app_theme.dart';

class AddItemPage extends StatefulWidget {
  final String? itemId;

  const AddItemPage({super.key, this.itemId});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _materialController = TextEditingController();
  String? _imageBase64;
  ClothingCategory? _category;
  String? _selectedColor;
  Season? _selectedSeason;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _isAnalyzing = false;
  String? _optimizedImageBase64;
  bool _isOptimizing = false;
  bool _showOptimized = false;

  final List<Map<String, dynamic>> _allColors = [
    {'name': '黑色', 'hex': '#000000', 'color': Colors.black},
    {'name': '白色', 'hex': '#FFFFFF', 'color': Colors.white},
    {'name': '蓝色', 'hex': '#2563EB', 'color': const Color(0xFF2563EB)},
    {'name': '红色', 'hex': '#EF4444', 'color': const Color(0xFFEF4444)},
    {'name': '米色', 'hex': '#D2B48C', 'color': const Color(0xFFD2B48C)},
    {'name': '灰色', 'hex': '#6B7280', 'color': const Color(0xFF6B7280)},
    {'name': '绿色', 'hex': '#22C55E', 'color': const Color(0xFF22C55E)},
    {'name': '黄色', 'hex': '#F59E0B', 'color': const Color(0xFFF59E0B)},
    {'name': '紫色', 'hex': '#A855F7', 'color': const Color(0xFFA855F7)},
    {'name': '粉色', 'hex': '#EC4899', 'color': const Color(0xFFEC4899)},
    {'name': '棕色', 'hex': '#92400E', 'color': const Color(0xFF92400E)},
    {'name': '藏青', 'hex': '#000080', 'color': const Color(0xFF000080)},
  ];

  static const _categories = [
    {'value': ClothingCategory.top, 'label': '上衣'},
    {'value': ClothingCategory.bottom, 'label': '裤子'},
    {'value': ClothingCategory.outerwear, 'label': '外套'},
    {'value': ClothingCategory.shoes, 'label': '鞋履'},
    {'value': ClothingCategory.accessory, 'label': '配饰'},
  ];

  static const _seasons = [
    {'value': Season.spring, 'label': '春季'},
    {'value': Season.summer, 'label': '夏季'},
    {'value': Season.autumn, 'label': '秋季'},
    {'value': Season.winter, 'label': '冬季'},
    {'value': Season.all, 'label': '四季'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      _isEditing = true;
      final wp = context.read<WardrobeProvider>();
      final item = wp.items.firstWhere(
        (i) => i.id == widget.itemId,
        orElse: () => throw Exception('Item not found'),
      );
      _nameController.text = item.name;
      _brandController.text = item.brand ?? '';
      _category = item.category;
      _selectedColor = item.color.isNotEmpty ? item.color.first : null;
      _selectedSeason = item.season;
      if (item.tags.isNotEmpty) _materialController.text = item.tags.first;
      if (item.images.isNotEmpty) _imageBase64 = item.images.first;
      if (item.optimizedImage != null) {
        _optimizedImageBase64 = item.optimizedImage;
        _showOptimized = true;
      }

      // Restore color palette from item
      if (item.colorPalette != null) {
        for (final p in item.colorPalette!) {
          if (!_allColors.any((c) => c['name'] == p['name'])) {
            final hex = p['hex'] ?? '#000000';
            final colorValue = int.tryParse(hex.replaceFirst('#', '0xFF'));
            _allColors.add({
              'name': p['name'] ?? '',
              'hex': hex,
              'color': Color(colorValue ?? 0xFF000000),
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isAnalyzing) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (file == null) return;

    final bytes = await File(file.path).readAsBytes();
    final base64String = base64Encode(bytes);
    setState(() {
      _imageBase64 = base64String;
    });

    // Auto-analyze in non-edit mode
    if (!_isEditing) {
      await _analyzeImage(base64String);
    }
  }

  Future<void> _analyzeImage(String base64Image) async {
    setState(() => _isAnalyzing = true);
    try {
      final aiServices = Provider.of<AIServiceProvider>(context, listen: false);
      final result = await aiServices.imageAnalyzer.analyzeClothingImage(
        base64Image,
      );
      if (!mounted) return;

      setState(() {
        _nameController.text = result.name;
        if (result.brand != null) _brandController.text = result.brand!;
        _category = result.category;
        _selectedSeason = result.season;
        _materialController.text = result.material;

        // Handle color: find matching or add new
        final exists = _allColors.any(
          (c) => (c['name'] as String) == result.color,
        );
        if (!exists && result.colorHex != null) {
          final hex = result.colorHex!;
          final colorValue = int.tryParse(hex.replaceFirst('#', '0xFF'));
          if (colorValue != null) {
            _allColors.add({
              'name': result.color,
              'hex': hex,
              'color': Color(colorValue),
            });
          }
        }
        _selectedColor = result.color;
      });

      debugPrint(
        '[ImageAnalysis] Auto-filled: ${result.name}, ${result.category.name}, ${result.color}',
      );
    } catch (e) {
      debugPrint('[ImageAnalysis] Failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'AI 识别失败：${e.toString().replaceFirst('Exception: ', '')}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _optimizeImage() async {
    if (_imageBase64 == null || _isOptimizing) return;

    setState(() => _isOptimizing = true);

    try {
      final aiServices = Provider.of<AIServiceProvider>(context, listen: false);
      final optimized = await aiServices.imageGenerator.optimizeClothingImage(
        _imageBase64!,
        color:
            _selectedColor, // Use currently selected color for background hint
      );

      if (!mounted) return;

      setState(() {
        _optimizedImageBase64 = optimized;
        _showOptimized = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('图片优化成功！'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('[ImageOptimize] Failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '优化失败：${e.toString().replaceFirst('Exception: ', '')}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isOptimizing = false);
    }
  }

  Future<void> _save() async {
    // Validation
    final errors = <String>[];
    if (_imageBase64 == null) errors.add('请上传衣物照片');
    if (_nameController.text.trim().isEmpty) errors.add('请输入衣物名称');
    if (_category == null) errors.add('请选择衣物分类');
    if (_selectedColor == null) errors.add('请选择衣物颜色');
    if (_selectedSeason == null) errors.add('请选择适用季节');
    if (_materialController.text.trim().isEmpty) errors.add('请输入材质信息');

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('请完善信息：\n${errors.join('\n')}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final wp = context.read<WardrobeProvider>();
    final name = _nameController.text.trim();

    // Build color palette for saving
    final colorPalette = _allColors
        .map((c) => {'name': c['name'] as String, 'hex': c['hex'] as String})
        .toList();

    try {
      if (_isEditing) {
        await wp.updateItem(
          widget.itemId!,
          name: name,
          category: _category,
          images: _imageBase64 != null ? [_imageBase64!] : null,
          color: _selectedColor != null ? [_selectedColor!] : [],
          season: _selectedSeason,
          tags: [
            _materialController.text.trim(),
          ].where((t) => t.isNotEmpty).toList(),
          brand: _brandController.text.trim().isNotEmpty
              ? _brandController.text.trim()
              : null,
          colorPalette: colorPalette,
          optimizedImage: _optimizedImageBase64,
        );
      } else {
        await wp.addItem(
          name: name,
          category: _category!,
          images: _imageBase64 != null ? [_imageBase64!] : [],
          color: _selectedColor != null ? [_selectedColor!] : [],
          season: _selectedSeason!,
          tags: [
            _materialController.text.trim(),
          ].where((t) => t.isNotEmpty).toList(),
          brand: _brandController.text.trim().isNotEmpty
              ? _brandController.text.trim()
              : null,
          colorPalette: colorPalette,
          optimizedImage: _optimizedImageBase64,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败：可能是因为图片过大或存储空间不足'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这件衣物吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<WardrobeProvider>().deleteItem(widget.itemId!);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPrimary,
      // Header matching React: close button left, title center, delete right
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.textTertiary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? '衣物详情' : '添加衣物',
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _deleteItem,
            )
          else
            const SizedBox(width: 48),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: context.borderColor),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ━━━ Image Upload Area (4:5 aspect ratio) ━━━
                GestureDetector(
                  onTap: _isAnalyzing ? null : _pickImage,
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.cardAlt.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _imageBase64 != null
                              ? AppTheme.primaryBlue.withValues(alpha: 0.3)
                              : context.borderColor,
                          width: 2,
                          strokeAlign: _imageBase64 != null
                              ? BorderSide.strokeAlignOutside
                              : BorderSide.strokeAlignCenter,
                        ),
                        boxShadow: _imageBase64 != null
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _imageBase64 != null
                          ? _buildImagePreview()
                          : _buildImagePlaceholder(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ━━━ 基础信息 Section ━━━
                _buildSectionTitle('基础信息'),
                const SizedBox(height: 20),

                // Name
                _buildFieldLabel('衣物名称'),
                const SizedBox(height: 8),
                _buildInputField(_nameController, '例如：白色亚麻衬衫'),
                const SizedBox(height: 16),

                // Category
                _buildFieldLabel('分类'),
                const SizedBox(height: 8),
                _buildCategorySelector(),

                const SizedBox(height: 32),

                // ━━━ 详细细节 Section ━━━
                _buildSectionTitle('详细细节'),
                const SizedBox(height: 20),

                // Color
                _buildFieldLabel('颜色'),
                const SizedBox(height: 12),
                _buildColorSelector(),
                const SizedBox(height: 20),

                // Season
                _buildFieldLabel('季节'),
                const SizedBox(height: 12),
                _buildSeasonSelector(),
                const SizedBox(height: 20),

                // Material
                _buildFieldLabel('材质'),
                const SizedBox(height: 8),
                _buildInputField(_materialController, '例如：100% 纯棉'),
                const SizedBox(height: 16),

                // Brand
                _buildFieldLabel('品牌'),
                const SizedBox(height: 8),
                _buildInputField(_brandController, '例如：优衣库'),
              ],
            ),
          ),

          // ━━━ Fixed Bottom Save Button ━━━
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.bgPrimary.withValues(alpha: 0.0),
                    context.bgPrimary.withValues(alpha: 0.8),
                    context.bgPrimary,
                  ],
                  stops: const [0.0, 0.3, 0.5],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isEditing ? '保存修改' : '保存到衣橱',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════ Image Area Widgets ═══════

  Widget _buildImagePreview() {
    final imageToShow = (_showOptimized && _optimizedImageBase64 != null)
        ? _optimizedImageBase64!
        : _imageBase64!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(base64Decode(imageToShow), fit: BoxFit.cover),

        // AI analyzing overlay
        if (_isAnalyzing || _isOptimizing)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryBlue,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isOptimizing ? 'AI 优化中...' : 'AI 识别中...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // Controls overlay (bottom-right)
        if (!_isAnalyzing && !_isOptimizing)
          Positioned(
            bottom: 12,
            right: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle Button (Show only if optimization exists)
                if (_optimizedImageBase64 != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOptimized = !_showOptimized;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _showOptimized ? Icons.undo : Icons.auto_fix_high,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                // Optimize Button (Show only if NOT optimized yet)
                if (_optimizedImageBase64 == null)
                  GestureDetector(
                    onTap: _optimizeImage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_fix_high,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                // Edit/Re-upload Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 28,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '点击上传照片',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.textTertiary,
          ),
        ),
      ],
    );
  }

  // ═══════ Section & Field Widgets ═══════

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: context.textTertiary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: TextStyle(color: context.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.textTertiary.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: context.cardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: context.borderColor.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: context.borderColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  // ═══════ Category Selector (Dropdown-style) ═══════

  Widget _buildCategorySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.cardAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor.withValues(alpha: 0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClothingCategory>(
          value: _category,
          hint: Text(
            '选择分类',
            style: TextStyle(
              color: context.textTertiary.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
          icon: Icon(Icons.expand_more, color: context.textTertiary),
          isExpanded: true,
          dropdownColor: context.cardColor,
          style: TextStyle(color: context.textPrimary, fontSize: 16),
          items: _categories.map((cat) {
            return DropdownMenuItem<ClothingCategory>(
              value: cat['value'] as ClothingCategory,
              child: Text(cat['label'] as String),
            );
          }).toList(),
          onChanged: (value) => setState(() => _category = value),
        ),
      ),
    );
  }

  // ═══════ Color Selector ═══════

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: _allColors.map((c) {
        final name = c['name'] as String;
        final color = c['color'] as Color;
        final selected = _selectedColor == name;
        return Tooltip(
          message: name,
          child: GestureDetector(
            onTap: () => setState(() => _selectedColor = name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppTheme.primaryBlue
                      : context.borderColor.withValues(alpha: 0.5),
                  width: selected ? 3 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              transform: selected
                  ? (Matrix4.identity()..scale(1.1))
                  : Matrix4.identity(),
              child: selected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════ Season Selector ═══════

  Widget _buildSeasonSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _seasons.map((s) {
          final season = s['value'] as Season;
          final label = s['label'] as String;
          final selected = _selectedSeason == season;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedSeason = season),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.primaryBlue : context.cardAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppTheme.primaryBlue
                        : context.borderColor.withValues(alpha: 0.5),
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : context.textTertiary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
