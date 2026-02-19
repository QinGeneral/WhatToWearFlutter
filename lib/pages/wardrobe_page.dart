import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/wardrobe_provider.dart';
import '../theme/app_theme.dart';
import 'add_item_page.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final wp = context.read<WardrobeProvider>();
    if (wp.items.isEmpty) wp.loadWardrobe();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WardrobeProvider>(
      builder: (context, wp, _) {
        final filtered = wp.filteredItems;
        return Scaffold(
          backgroundColor: context.bgAlt,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AddItemPage()));
              if (mounted) wp.loadWardrobe();
            },
            backgroundColor: AppTheme.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => wp.setSearchQuery(v),
                    style: TextStyle(color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: '搜索衣物...',
                      hintStyle: TextStyle(color: context.textTertiary),
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.textTertiary,
                      ),
                      filled: true,
                      fillColor: context.cardColor.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                // Category filter
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _CategoryChip(
                        label: '全部',
                        selected: wp.selectedCategory == null,
                        onTap: () => wp.setCategory(null),
                      ),
                      ...ClothingCategory.values.map(
                        (cat) => _CategoryChip(
                          label: cat.label,
                          selected: wp.selectedCategory == cat,
                          onTap: () => wp.setCategory(cat),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Items grid
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.checkroom,
                                size: 64,
                                color: context.textTertiary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                wp.items.isEmpty
                                    ? '衣橱为空，点击 + 添加衣物'
                                    : '没有找到匹配的衣物',
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.72,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _WardrobeItemCard(item: filtered[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryBlue : context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppTheme.primaryBlue : context.borderColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : context.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _WardrobeItemCard extends StatelessWidget {
  final WardrobeItem item;

  const _WardrobeItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => AddItemPage(itemId: item.id)));
        if (context.mounted) {
          context.read<WardrobeProvider>().loadWardrobe();
        }
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
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildImage(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category.label,
                    style: TextStyle(fontSize: 11, color: context.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
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
      child: Center(
        child: Icon(
          Icons.checkroom,
          size: 40,
          color: context.textTertiary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
